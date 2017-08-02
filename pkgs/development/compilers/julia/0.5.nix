{ stdenv, fetchgit, fetchurl, fetchzip
# build tools
, gfortran, m4, makeWrapper, patchelf, perl, which, python2
, runCommand
, paxctl
# libjulia dependencies
, libunwind, readline, utf8proc, zlib
, llvm, libffi, ncurses
# standard library dependencies
, curl, fftwSinglePrec, fftw, gmp, libgit2, mpfr, openlibm, openspecfun, pcre2
# linear algebra
, openblas, arpack, suitesparse
# Darwin frameworks
, CoreServices, ApplicationServices
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
  dsfmtVersion = "2.2.3";
  dsfmt = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmtVersion}.tar.gz";
    sha256 = "03kaqbjbi6viz0n33dk5jlf6ayxqlsq4804n7kwkndiga9s4hd42";
  };

  libuvVersion = "8d5131b6c1595920dd30644cd1435b4f344b46c8";
  libuv = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/libuv/tarball/${libuvVersion}";
    sha256 = "1886r04igcs0k24sbb61wn10f8ki35c39jsnc5djv3rg4hvn9l49";
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
  version = "0.5.2";
  name = "${pname}-${version}";

  src = fetchzip {
    url = "https://github.com/JuliaLang/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1616f53dj7xc0g2iys8qfbzal6dx55nswnws5g5r44dlbf4hcl0h";
  };
  prePatch = ''
    mkdir deps/srccache
    cp "${dsfmt}" "./deps/srccache/dsfmt-${dsfmtVersion}.tar.gz"
    cp "${rmath-julia}" "./deps/srccache/Rmath-julia-${rmathVersion}.tar.gz"
    cp "${libuv}" "./deps/srccache/libuv-${libuvVersion}.tar.gz"
    cp "${virtualenv}" "./deps/srccache/virtualenv-${virtualenvVersion}.tar.gz"
  '';

  patches = [
    ./0001.1-use-system-utf8proc.patch
    ./0002-use-system-suitesparse.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./0004-hardened.patch;

  postPatch = ''
    patchShebangs . contrib
    for i in backtrace replutil cmdlineargs compile; do
      mv test/$i.jl{,.off}
      touch test/$i.jl
    done
  '';

  buildInputs = [
    arpack fftw fftwSinglePrec gmp libgit2 libunwind mpfr
    pcre2.dev openblas openlibm openspecfun readline suitesparse utf8proc
    zlib llvm
  ]
  ++ stdenv.lib.optionals stdenv.isDarwin [CoreServices ApplicationServices]
  ;

  nativeBuildInputs = [ curl gfortran m4 makeWrapper patchelf perl python2 which ]
    ++ stdenv.lib.optional stdenv.needsPax paxctl;

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
      
      "USE_SYSTEM_LLVM=1"
      "LLVM_VER=3.8.1"

      "USE_SYSTEM_MPFR=1"
      "USE_SYSTEM_OPENLIBM=1"
      "USE_SYSTEM_OPENSPECFUN=1"
      "USE_SYSTEM_PATCHELF=1"
      "USE_SYSTEM_PCRE=1"
      "PCRE_CONFIG=${pcre2.dev}/bin/pcre2-config"
      "PCRE_INCL_PATH=${pcre2.dev}/include/pcre2.h"
      "USE_SYSTEM_READLINE=1"
      "USE_SYSTEM_UTF8PROC=1"
      "USE_SYSTEM_ZLIB=1"
    ];

  NIX_CFLAGS_COMPILE = [ "-fPIC" ];

  LD_LIBRARY_PATH = makeLibraryPath [
    arpack fftw fftwSinglePrec gmp libgit2 mpfr openblas openlibm
    openspecfun pcre2 suitesparse llvm
  ];

  dontStrip = true;
  dontPatchELF = true;

  enableParallelBuilding = true;

  doCheck = !stdenv.isDarwin;
  checkTarget = "testall";
  # Julia's tests require read/write access to $HOME
  preCheck = ''
    export HOME="$NIX_BUILD_TOP"
    set
  '';

  preBuild = ''
    sed -e '/^install:/s@[^ ]*/doc/[^ ]*@@' -i Makefile
    sed -e '/[$](DESTDIR)[$](docdir)/d' -i Makefile
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
  '';

  postInstall = ''
    for prog in "$out/bin/julia" "$out/bin/julia-debug"; do
        wrapProgram "$prog" \
            --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH:$out/lib/julia" \
            --prefix PATH : "${stdenv.lib.makeBinPath [ curl ]}"
    done
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = http://julialang.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isi686;
  };
}
