{ stdenv, fetchgit, fetchurl
# build tools
, gfortran, m4, makeWrapper, patchelf, perl, which, python2
# libjulia dependencies
, libunwind, readline, utf8proc, zlib
# standard library dependencies
, curl, fftwSinglePrec, fftw, gmp, libgit2, mpfr, openlibm, openspecfun, pcre2
# linear algebra
, openblas, arpack, suitesparse
}:

with stdenv.lib;

# All dependencies must use the same OpenBLAS.
let
  arpack_ = arpack;
  suitesparse_ = suitesparse;
in
let
  arpack = arpack_.override { inherit openblas; };
  suitesparse = suitesparse_.override { inherit openblas; };
in

let
  llvmVersion = "3.7.1";
  llvm = fetchurl {
    url = "http://llvm.org/releases/${llvmVersion}/llvm-${llvmVersion}.src.tar.xz";
    sha256 = "1masakdp9g2dan1yrazg7md5am2vacbkb3nahb3dchpc1knr8xxy";
  };

  dsfmtVersion = "2.2.3";
  dsfmt = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmtVersion}.tar.gz";
    sha256 = "03kaqbjbi6viz0n33dk5jlf6ayxqlsq4804n7kwkndiga9s4hd42";
  };

  libuvVersion = "a1d9166a440e4a0664c0e6de6ebe25350de56a42";
  libuv = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/libuv/tarball/${libuvVersion}";
    sha256 = "1sjvly4ylfyj8kxnx0gsjj2f70cg17h302h1i08gfndrqam68za5";
  };

  rmathVersion = "0.1";
  rmath-julia = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/Rmath-julia/tarball/v${rmathVersion}";
    sha256 = "0ai5dhjc43zcvangz123ryxmlbm51s21rg13bllwyn98w67arhb4";
  };
  
  virtualenvVersion = "15.0.0";
  virtualenv = fetchurl {
    url = "mirror://pypi/v/virtualenv/virtualenv-${virtualenvVersion}.tar.gz";
    sha256 = "06fw4liazpx5vf3am45q2pdiwrv0id7ckv7n6zmpml29x6vkzmkh";
  };
in

stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.5.0-dev-2016-06-10";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://github.com/JuliaLang/${pname}";
    rev = "56d7d6672c7db717dacb5e34f485180c2eba83b2";
    sha256 = "1wbrzdrxp94i7yxdgf3qgrjshmqxi0c4bqz7wy0c0c0kjlg6flmx";
  };

  prePatch = ''
    mkdir deps/srccache
    cp "${llvm}" "./deps/srccache/llvm-${llvmVersion}.src.tar.xz"
    cp "${dsfmt}" "./deps/srccache/dsfmt-${dsfmtVersion}.tar.gz"
    cp "${rmath-julia}" "./deps/srccache/Rmath-julia-${rmathVersion}.tar.gz"
    cp "${libuv}" "./deps/srccache/libuv-${libuvVersion}.tar.gz"
    cp "${virtualenv}" "./deps/srccache/virtualenv-${virtualenvVersion}.tar.gz"
  '';

  patches = [
    ./0001.1-use-system-utf8proc.patch
    ./0002-use-system-suitesparse.patch
  ];

  postPatch = ''
    patchShebangs . contrib
  '';

  buildInputs = [
    arpack fftw fftwSinglePrec gmp libgit2 libunwind mpfr
    pcre2 openblas openlibm openspecfun readline suitesparse utf8proc
    zlib
  ];

  nativeBuildInputs = [ curl gfortran m4 makeWrapper patchelf perl python2 which ];

  makeFlags =
    let
      arch = head (splitString "-" stdenv.system);
      march = { "x86_64" = "x86-64"; "i686" = "pentium4"; }."${arch}"
              or (throw "unsupported architecture: ${arch}");
      # Julia requires Pentium 4 (SSE2) or better
      cpuTarget = { "x86_64" = "x86-64"; "i686" = "pentium4"; }."${arch}"
                  or (throw "unsupported architecture: ${arch}");
    in [
      "ARCH=${arch}"
      "MARCH=${march}"
      "JULIA_CPU_TARGET=${cpuTarget}"
      "PREFIX=$(out)"
      "prefix=$(out)"
      "SHELL=${stdenv.shell}"

      "USE_SYSTEM_BLAS=1"
      "USE_BLAS64=${if openblas.blas64 then "1" else "0"}"
      "LIBBLAS=-lopenblas"
      "LIBBLASNAME=libopenblas"

      "USE_SYSTEM_LAPACK=1"
      "LIBLAPACK=-lopenblas"
      "LIBLAPACKNAME=libopenblas"

      "USE_SYSTEM_SUITESPARSE=1"
      "SUITESPARSE_LIB=-lsuitesparse"
      "SUITESPARSE_INC=-I${suitesparse}/include"

      "USE_SYSTEM_ARPACK=1"
      "USE_SYSTEM_FFTW=1"
      "USE_SYSTEM_GMP=1"
      "USE_SYSTEM_LIBGIT2=1"
      "USE_SYSTEM_LIBUNWIND=1"
      # 'replutil' test failure with LLVM 3.8.0, invalid libraries with 3.7.1
      "USE_SYSTEM_LLVM=0"
      "USE_SYSTEM_MPFR=1"
      "USE_SYSTEM_OPENLIBM=1"
      "USE_SYSTEM_OPENSPECFUN=1"
      "USE_SYSTEM_PATCHELF=1"
      "USE_SYSTEM_PCRE=1"
      "USE_SYSTEM_READLINE=1"
      "USE_SYSTEM_UTF8PROC=1"
      "USE_SYSTEM_ZLIB=1"
    ];

  NIX_CFLAGS_COMPILE = [ "-fPIC" ];

  LD_LIBRARY_PATH = makeLibraryPath [
    arpack fftw fftwSinglePrec gmp libgit2 mpfr openblas openlibm
    openspecfun pcre2 suitesparse
  ];

  dontStrip = true;
  dontPatchELF = true;

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "testall";
  # Julia's tests require read/write access to $HOME
  preCheck = ''
    export HOME="$NIX_BUILD_TOP"
  '';

  preBuild = ''
    sed -e '/^install:/s@[^ ]*/doc/[^ ]*@@' -i Makefile
    sed -e '/[$](DESTDIR)[$](docdir)/d' -i Makefile
  '';

  postInstall = ''
    for prog in "$out/bin/julia" "$out/bin/julia-debug"; do
        wrapProgram "$prog" \
            --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
            --prefix PATH : "${stdenv.lib.makeBinPath [ curl ]}"
    done
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isi686;
  };
}
