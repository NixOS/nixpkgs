{ stdenv, git, openssl, autoconf, pkgs, makeStaticLibraries, version, gcc, src, coreutils }:

# Note that according to a benchmark run by Marc Feeley on May 2018,
# clang is 10x (with default settings) to 15% (with -O2) slower than GCC at compiling
# Gambit output, producing code that is 3x slower. IIRC the benchmarks from Gambit@30,
# the numbers were still heavily in favor of GCC in October 2019.
# Thus we use GCC over clang, even on macOS.

# Also note that I (fare) just ran benchmarks from https://github.com/ecraven/r7rs-benchmarks
# with Gambit 4.9.3 with -O1 vs -O2 vs -Os on Feb 2020. Which wins depends on the benchmark.
# The fight is unclear between -O1 and -O2, where -O1 wins more often, by up to 17%,
# but sometimes -O2 wins, once by up to 43%, so that overall -O2 is 5% faster.
# However, -Os seems more consistent in winning slightly against both -O1 and -O2,
# and is overall 15% faster than -O2. As for compile times, -O1 is fastest,
# -Os is about 29%-33% slower than -O1, while -O2 is about 40%-50% slower than -O1.
# Overall, -Os seems like the best choice, and that's what we now use.

stdenv.mkDerivation rec {
  pname = "gambit";
  inherit version;
  inherit src;

  bootstrap = import ./bootstrap.nix ( pkgs );

  # TODO: if/when we can get all the library packages we depend on to have static versions,
  # we could use something like (makeStaticLibraries openssl) to enable creation
  # of statically linked binaries by gsc.
  buildInputs = [ git autoconf bootstrap openssl ];

  configureFlags = [
    "--enable-single-host"
    "--enable-c-opt=-Os"
    "--enable-gcc-opts"
    "--enable-shared"
    "--enable-absolute-shared-libs" # Yes, NixOS will want an absolute path, and fix it.
    "--enable-poll"
    "--enable-openssl"
    "--enable-default-runtime-options=f8,-8,t8" # Default to UTF-8 for source and all I/O
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
  ];

  configurePhase = ''
    export CC=${gcc}/bin/gcc CXX=${gcc}/bin/g++ \
           CPP=${gcc}/bin/cpp CXXCPP=${gcc}/bin/cpp LD=${gcc}/bin/ld \
           XMKMF=${coreutils}/bin/false
    unset CFLAGS LDFLAGS LIBS CPPFLAGS CXXFLAGS
    ./configure --prefix=$out ${builtins.concatStringsSep " " configureFlags}

    # OS-specific paths are hardcoded in ./configure
    substituteInPlace config.status \
      --replace /usr/local/opt/openssl/lib "${openssl.out}/lib" \
      --replace /usr/local/opt/openssl@1.1/lib "${openssl.out}/lib"
    ./config.status
  '';

  buildPhase = ''
    # Make bootstrap compiler, from release bootstrap
    mkdir -p boot &&
    cp -rp ${bootstrap}/. boot/. &&
    chmod -R u+w boot &&
    cd boot &&
    cp ../gsc/makefile.in ../gsc/*.scm gsc && # */
    ./configure &&
    for i in lib gsi gsc ; do (cd $i ; make ) ; done &&
    cd .. &&
    cp boot/gsc/gsc gsc-boot &&

    # Now use the bootstrap compiler to build the real thing!
    make -j2 from-scratch
  '';

  doCheck = true;

  meta = {
    description = "Optimizing Scheme to C compiler";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    # NB regarding platforms: only actually tested on Linux, *should* work everywhere,
    # but *might* need adaptation e.g. on macOS.
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
