{
  gccStdenv,
  lib,
  pkgs,
  git,
  openssl,
  autoconf,
  gcc,
  coreutils,
  gnused,
  gnugrep,
  makeStaticLibraries,
  src,
  version,
  git-version,
  stampYmd ? 0,
  stampHms ? 0,
  gambit-support,
  optimizationSetting ? "-O1",
  gambit-params ? pkgs.gambit-support.stable-params,
  rev ? git-version,
}:

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

  passthru = {
    inherit
      src
      version
      git-version
      rev
      stampYmd
      stampHms
      optimizationSetting
      openssl
      ;
  };

  nativeBuildInputs = [
    git
    autoconf
  ];

  # TODO: if/when we can get all the library packages we depend on to have static versions,
  # we could use something like (makeStaticLibraries openssl) to enable creation
  # of statically linked binaries by gsc.
  buildInputs = [ openssl ];

  # TODO: patch gambit's source so it has the full path to sed, grep, fgrep? Is there more?
  # Or wrap relevant programs to add a suitable PATH ?
  #runtimeDeps = [ gnused gnugrep ];

  configureFlags =
    [
      "--enable-targets=${gambit-params.targets}"
      "--enable-single-host"
      "--enable-c-opt=${optimizationSetting}"
      "--enable-c-opt-rts=-O2"
      "--enable-gcc-opts"
      "--enable-trust-c-tco"
      "--enable-shared"
      "--enable-absolute-shared-libs" # Yes, NixOS will want an absolute path, and fix it.
      "--enable-openssl"
      "--enable-dynamic-clib"
      #"--enable-default-compile-options='(compactness 9)'" # Make life easier on the JS backend
      "--enable-default-runtime-options=${gambit-params.defaultRuntimeOptions}"
      # "--enable-rtlib-debug" # used by Geiser, but only on recent-enough gambit, and messes js runtime
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
      # "--enable-march=native" # Nope, makes it not work on machines older than the builder
    ]
    ++ gambit-params.extraOptions
    # TODO: pick an appropriate architecture to optimize on on x86-64?
    # https://gcc.gnu.org/onlinedocs/gcc-4.8.4/gcc/i386-and-x86-64-Options.html#i386-and-x86-64-Options
    # ++ lib.optional pkgs.stdenv.isx86_64 "--enable-march=core-avx2"
    # Do not enable poll on darwin due to https://github.com/gambit/gambit/issues/498
    ++ lib.optional (!gccStdenv.isDarwin) "--enable-poll";

  configurePhase = ''
    export CC=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}gcc \
           CXX=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}g++ \
           CPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           CXXCPP=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}cpp \
           LD=${gccStdenv.cc}/bin/${gccStdenv.cc.targetPrefix}ld \
           XMKMF=${coreutils}/bin/false
    unset CFLAGS LDFLAGS LIBS CPPFLAGS CXXFLAGS

    ${gambit-params.fixStamp git-version stampYmd stampHms}

    ./configure --prefix=$out/gambit ${builtins.concatStringsSep " " configureFlags}

    # OS-specific paths are hardcoded in ./configure
    substituteInPlace config.status \
      ${
        lib.optionalString (
          gccStdenv.isDarwin && !gambit-params.stable
        ) ''--replace "/usr/local/opt/openssl@1.1" "${lib.getLib openssl}"''
      } \
        --replace "/usr/local/opt/openssl" "${lib.getLib openssl}"

    ./config.status
  '';

  buildPhase = ''
    # The MAKEFLAGS setting is a workaround for https://github.com/gambit/gambit/issues/833
    export MAKEFLAGS="--output-sync=recurse"
    echo "Make bootstrap compiler, from release bootstrap"
    mkdir -p boot
    cp -rp ${bootstrap}/gambit/. boot/.
    chmod -R u+w boot
    cd boot
    cp ../gsc/makefile.in ../gsc/*.scm gsc/
    echo > include/stamp.h # No stamp needed for the bootstrap compiler
    ./configure
    for i in lib gsi gsc ; do (cd $i ; make -j$NIX_BUILD_CORES) ; done
    cd ..
    cp boot/gsc/gsc gsc-boot

    echo "Now use the bootstrap compiler to build the real thing!"
    make -j$NIX_BUILD_CORES from-scratch
    ${lib.optionalString gambit-params.modules "make -j$NIX_BUILD_CORES modules"}
  '';

  postInstall = ''
    mkdir $out/bin
    cd $out/bin
    ln -s ../gambit/bin/* .
  '';

  doCheck = true;
  dontStrip = true;

  meta = gambit-support.meta;
}
