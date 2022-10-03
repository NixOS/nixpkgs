{ lib
, stdenv
, fetchurl
, which
, python3
, gfortran
, gcc
, cmake
, perl
, gnum4
, libwhich
, libxml2
, libunwind
, libgit2
, curl
, nghttp2
, mbedtls
, libssh2
, gmp
, mpfr
, suitesparse
, utf8proc
, zlib
, p7zip
, ncurses
, pcre2
}:

stdenv.mkDerivation rec {
  pname = "julia";
  version = "1.8.2";

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    sha256 = "sha256-5Xz8Lm2JF1Ckf3zwNVmk6PchK/VJAPJqnxL9bQCdTKk=";
  };

  patches =
    let
      path = name: "https://raw.githubusercontent.com/archlinux/svntogit-community/6fd126d089d44fdc875c363488a7c7435a223cec/trunk/${name}";
    in
    [
      (fetchurl {
        url = path "julia-hardcoded-libs.patch";
        sha256 = "sha256-kppSpVA7bRohd0wXDs4Jgct9ocHnpbeiiSz7ElFom1U=";
      })
      (fetchurl {
        url = path "julia-libunwind-1.6.patch";
        sha256 = "sha256-zqMh9+Fjgd15XuINe9Xtpk+bRTwB0T6WCWLrJyOQfiQ=";
      })
      ./patches/1.8/0001-skip-symlink-system-libraries.patch
      ./patches/1.8/0002-skip-building-doc.patch
      ./patches/1.8/0003-skip-failing-tests.patch
      ./patches/1.8/0004-ignore-absolute-path-when-loading-library.patch
    ];

  nativeBuildInputs = [
    which
    python3
    gfortran
    cmake
    perl
    gnum4
    libwhich
  ];

  buildInputs = [
    libxml2
    libunwind
    libgit2
    curl
    nghttp2
    mbedtls
    libssh2
    gmp
    mpfr
    utf8proc
    zlib
    p7zip
    pcre2
  ];

  JULIA_RPATH = lib.makeLibraryPath (buildInputs ++ [ stdenv.cc.cc gfortran.cc ncurses ]);

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs .
  '';

  LDFLAGS = "-Wl,-rpath,${JULIA_RPATH}";

  makeFlags = [
    "prefix=$(out)"
    "USE_BINARYBUILDER=0"
    "USE_SYSTEM_CSL=1"
    "USE_SYSTEM_LLVM=0" # a patched version is required
    "USE_SYSTEM_LIBUNWIND=1"
    "USE_SYSTEM_PCRE=1"
    "USE_SYSTEM_LIBM=0"
    "USE_SYSTEM_OPENLIBM=0"
    "USE_SYSTEM_DSFMT=0" # not available in nixpkgs
    "USE_SYSTEM_LIBBLASTRAMPOLINE=0" # not available in nixpkgs
    "USE_SYSTEM_BLAS=0" # test failure
    "USE_SYSTEM_LAPACK=0" # test failure
    "USE_SYSTEM_GMP=1"
    "USE_SYSTEM_MPFR=1"
    "USE_SYSTEM_LIBSUITESPARSE=0" # test failure
    "USE_SYSTEM_LIBUV=0" # a patched version is required
    "USE_SYSTEM_UTF8PROC=1"
    "USE_SYSTEM_MBEDTLS=1"
    "USE_SYSTEM_LIBSSH2=1"
    "USE_SYSTEM_NGHTTP2=1"
    "USE_SYSTEM_CURL=1"
    "USE_SYSTEM_LIBGIT2=1"
    "USE_SYSTEM_PATCHELF=1"
    "USE_SYSTEM_LIBWHICH=1"
    "USE_SYSTEM_ZLIB=1"
    "USE_SYSTEM_P7ZIP=1"

    "PCRE_INCL_PATH=${pcre2.dev}/include/pcre2.h"
  ];

  doInstallCheck = true;
  installCheckTarget = "testall";

  preInstallCheck = ''
    export HOME="$TMPDIR"
    export JULIA_TEST_USE_MULTIPLE_WORKERS="true"
  '';

  dontStrip = true;

  postFixup = ''
    for file in $out/bin/julia $out/lib/libjulia.so $out/lib/julia/libjulia-internal.so $out/lib/julia/libjulia-codegen.so; do
      patchelf --set-rpath "$out/lib:$out/lib/julia:${JULIA_RPATH}" $file
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
