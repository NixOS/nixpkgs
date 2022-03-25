{ gccStdenv, lib, git, openssl, autoconf, pkgs, makeStaticLibraries, gcc, coreutils, gnused, gnugrep,
  src, version, git-version,
  gambit-support, optimizationSetting ? "-O1", gambit-params ? pkgs.gambit-support.stable-params }:

# Note that according to a benchmark run by Marc Feeley on May 2018,
# clang is 10x (with default settings) to 15% (with -O2) slower than GCC at compiling
# Gambit output, producing code that is 3x slower. IIRC the benchmarks from Gambit@30,
# the numbers were still heavily in favor of GCC in October 2019.
# Thus we use GCC over clang, even on macOS.
#
# Also note that I (fare) just ran benchmarks from https://github.com/ecraven/r7rs-benchmarks
# with Gambit 4.9.3 with -O1 vs -O2 vs -Os on Feb 2020. Which wins depends on the benchmark.
# The fight is unclear between -O1 and -O2, where -O1 wins more often, by up to 17%,
# but sometimes -O2 wins, once by up to 43%, so that overall -O2 is 5% faster.
# However, -Os seems more consistent in winning slightly against both -O1 and -O2,
# and is overall 15% faster than -O2. As for compile times, -O1 is fastest,
# -Os is about 29%-33% slower than -O1, while -O2 is about 40%-50% slower than -O1.
#
# Overall, -Os seems like the best choice, but I care more about compile-time,
# so I stick with -O1 (in the defaults above), which is also the default for Gambit.

gccStdenv.mkDerivation rec {

  pname = "gambit";
  inherit src version git-version;
  bootstrap = gambit-support.gambit-bootstrap;

  nativeBuildInputs = [ git autoconf ];
  # TODO: if/when we can get all the library packages we depend on to have static versions,
  # we could use something like (makeStaticLibraries openssl) to enable creation
  # of statically linked binaries by gsc.
  buildInputs = [ openssl ];

  # TODO: patch gambit's source so it has the full path to sed, grep, fgrep? Is there more?
  # Or wrap relevant programs to add a suitable PATH ?
  #runtimeDeps = [ gnused gnugrep ];

  # disable stackprotector on aarch64-darwin for now
  # build error:
  # ```
  # /private/tmp/nix-build-gambit-unstable-2020-09-20.drv-0/ccIjyeeb.s:207:15: error: index must be an integer in range [-256, 255].
  #         ldr     x2, [x2, ___stack_chk_guard];momd
  #                          ^
  # ```
  hardeningDisable = lib.optionals (gccStdenv.isAarch64 && gccStdenv.isDarwin) [ "stackprotector" ];

  configureFlags = [
    "--enable-targets=${gambit-params.targets}"
    "--enable-single-host"
    "--enable-c-opt=${optimizationSetting}"
    "--enable-gcc-opts"
    "--enable-shared"
    "--enable-absolute-shared-libs" # Yes, NixOS will want an absolute path, and fix it.
    "--enable-openssl"
    "--enable-default-runtime-options=${gambit-params.defaultRuntimeOptions}"
    # "--enable-debug" # Nope: enables plenty of good stuff, but also the costly console.log
    # "--enable-multiple-versions" # Nope, NixOS already does version multiplexing
    # "--enable-guide"
    # "--enable-track-scheme"
    # "--enable-high-res-timing"
    # "--enable-max-processors=4"
    # "--enable-multiple-vms"
    # "--enable-dynamic-tls"
    # "--enable-multiple-threaded-vms"  # when SMP branch is merged in
    # "--enable-thread-system=posix"    # default when --enable-multiple-vms is on.
    # "--enable-profile"
    # "--enable-coverage"
    # "--enable-inline-jumps"
    # "--enable-char-size=1" # default is 4
  ] ++
    # due not enable poll on darwin due to https://github.com/gambit/gambit/issues/498
    lib.optional (!gccStdenv.isDarwin) "--enable-poll";

  configurePhase = ''
    export CC=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc \
           CXX=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++ \
           CPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           CXXCPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           LD=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}ld \
           XMKMF=${coreutils}/bin/false
    unset CFLAGS LDFLAGS LIBS CPPFLAGS CXXFLAGS

    ${gambit-params.fix-stamp git-version}

    ./configure --prefix=$out/gambit ${builtins.concatStringsSep " " configureFlags}

    # OS-specific paths are hardcoded in ./configure
    substituteInPlace config.status \
      --replace "/usr/local/opt/openssl@1.1" "${lib.getLib openssl}" \
      --replace "/usr/local/opt/openssl" "${lib.getLib openssl}"

    ./config.status
  '';

  buildPhase = ''
    # Make bootstrap compiler, from release bootstrap
    mkdir -p boot
    cp -rp ${bootstrap}/gambit/. boot/.
    chmod -R u+w boot
    cd boot
    cp ../gsc/makefile.in ../gsc/*.scm gsc/
    ./configure
    for i in lib gsi gsc ; do (cd $i ; make -j$NIX_BUILD_CORES) ; done
    cd ..
    cp boot/gsc/gsc gsc-boot

    # Now use the bootstrap compiler to build the real thing!
    make -j$NIX_BUILD_CORES from-scratch
    ${lib.optionalString gambit-params.modules "make -j$NIX_BUILD_CORES modules"}
  '';

  postInstall = ''
    mkdir $out/bin
    cd $out/bin
    ln -s ../gambit/bin/* .
  '';

  doCheck = true;

  meta = gambit-support.meta;
}
