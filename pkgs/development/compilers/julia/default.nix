{ stdenv
, fetchurl
# see https://github.com/JuliaLang/julia/blob/master/doc/build/build.md
# not native
, libunwind
, pcre2
, blas
, lapack
, mpfr
, suitesparse
, utf8proc
, mbedtls
, libssh2
, curl
, libgit2
, patchelf
, zlib
, p7zip
, enableMKL ? true # not free
, libmFlavor ? "julia" # Julia's openlibm is the only libm we have packaged
# native
, m4
, gfortran
, perl
, python3
, which
, cmake
}:

let
  majorVersion = "1";
  minorVersion = "5";
  maintenanceVersion = "1";
  version = "${majorVersion}.${minorVersion}.${maintenanceVersion}";
in

stdenv.mkDerivation rec {
  pname = "julia";
  inherit version;

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    sha256 = "1m5iz5ikl0y1yvpmy7ys6a4l7xwn38mxsqm8g820gkf7rzyfn38x";
  };

  buildInputs = [
    libunwind
    pcre2
    blas
    lapack
    mpfr
    suitesparse
    utf8proc
    mbedtls
    libssh2
    curl
    libgit2
    patchelf
    zlib
    p7zip
  ];

  makeFlags = [
    # Don't use the internet
    "USE_BINARYBUILDER=0"
    "PREFIX=$(out)"
    "prefix=$(out)"

    "USE_SYSTEM_LIBUNWIND=1"
    # Weirdly, the build fails if it's set to 1, with the error:
    #
    # make[1]: *** No rule to make target '/nix/store/a7y8xjdxarhsya8n180m35p05h7khgib-pcre2-10.35/include/pcre2.h', needed by 'pcre_h.jl'.  Stop.
    "USE_SYSTEM_PCRE=0"
    # TODO: Package http://www.math.sci.hiroshima-u.ac.jp/~m-mat@math.sci.hiroshima-u.ac.jp/MT/SFMT/#dSFMT
    "USE_SYSTEM_DSFMT=0"
    "USE_SYSTEM_BLAS=1"
    "USE_SYSTEM_LAPACK=1"

    # See https://discourse.julialang.org/t/no-documentation-for-the-state-of-patches-for-dependencies-of-julia/44735/8
    # and https://github.com/JuliaLang/julia/pull/31215
    "USE_SYSTEM_GMP=0"
    # The only deps that will probably never be used from the system
    "USE_SYSTEM_LIBUV=0"
    "USE_SYSTEM_LLVM=0"

    "USE_SYSTEM_MPFR=1"
    "USE_SYSTEM_SUITESPARSE=1"
    "USE_SYSTEM_UTF8PROC=1"
    "USE_SYSTEM_MBEDTLS=1"
    "USE_SYSTEM_LIBSSH2=1"
    "USE_SYSTEM_CURL=1"
    "USE_SYSTEM_LIBGIT2=1"
    "USE_SYSTEM_PATCHELF=1"
    "USE_SYSTEM_ZLIB=1"
    "USE_SYSTEM_P7ZIP=1"
  ]
    ++ stdenv.lib.optionals enableMKL [ "USE_INTEL_MKL=1" ]
    # Choose a libm flavor to use. Currently only openlibm is supported - by julia.
    # TODO: Package intel's libm and this: https://hpc.llnl.gov/software/mathematical-software/libm
    ++ stdenv.lib.optionals (libmFlavor == "julia") [ "USE_SYSTEM_OPENLIBM=1" ]
    ++ stdenv.lib.optionals (libmFlavor == "intel") [ "USE_INTEL_LIBM=1" ]
    ++ stdenv.lib.optionals (libmFlavor == "llnl") [ "USE_SYSTEM_LIBM=1" ]
  ;

  nativeBuildInputs = [
    m4
    # needed by makefile, undeclared by upstream, see https://github.com/JuliaLang/julia/issues/36604
    which
    perl
    gfortran
    python3
  ];
  # Cmake is needed to build some deps found in the tarball we fetch, and that
  # Julia is eventually going to be using. Because Julia itself uses plain make
  # files as a build system, we need to add cmake to $PATH and not make our own
  # stdenv use cmake as the build system.
  preConfigure = ''
    export PATH=$PATH:${cmake}/bin
  '';

  # doCheck = true;

  passthru = {
    inherit majorVersion minorVersion maintenanceVersion;
    site = "share/julia/site/v${majorVersion}.${minorVersion}";
  };

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ doronbehar raskin rob garrison ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isi686;
  };
}
