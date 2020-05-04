{ majorVersion
, minorVersion
, maintenanceVersion
, src_sha256
# source deps
, libuvVersion
, libuvSha256
}:
{ stdenv, fetchurl, fetchzip
# build tools
, gfortran, m4, makeWrapper, patchelf, perl, which, python2
, cmake
# libjulia dependencies
, libunwind, readline, utf8proc, zlib
# standard library dependencies
, curl, fftwSinglePrec, fftw, gmp, libgit2, mpfr, openlibm, openspecfun, pcre2
# linear algebra
, blas, lapack, arpack
# Darwin frameworks
, CoreServices, ApplicationServices
}:

with stdenv.lib;

assert (!blas.isILP64) && (!lapack.isILP64);

let
  dsfmtVersion = "2.2.3";
  dsfmt = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmtVersion}.tar.gz";
    sha256 = "03kaqbjbi6viz0n33dk5jlf6ayxqlsq4804n7kwkndiga9s4hd42";
  };

  libuv = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/libuv/tarball/${libuvVersion}";
    sha256 = libuvSha256;
  };

  rmathVersion = "0.1";
  rmath-julia = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/Rmath-julia/tarball/v${rmathVersion}";
    sha256 = "1qyps217175qhid46l8f5i1v8i82slgp23ia63x2hzxwfmx8617p";
  };

  virtualenvVersion = "15.0.0";
  virtualenv = fetchurl {
    url = "mirror://pypi/v/virtualenv/virtualenv-${virtualenvVersion}.tar.gz";
    sha256 = "06fw4liazpx5vf3am45q2pdiwrv0id7ckv7n6zmpml29x6vkzmkh";
  };

  libwhichVersion = "81e9723c0273d78493dc8c8ed570f68d9ce7e89e";
  libwhich = fetchurl {
    url = "https://api.github.com/repos/vtjnash/libwhich/tarball/${libwhichVersion}";
    sha256 = "1p7zg31kpmpbmh1znrk1xrbd074agx13b9q4dcw8n2zrwwdlbz3b";
  };

  llvmVersion = "6.0.0";
  llvm = fetchurl {
    url = "http://releases.llvm.org/6.0.0/llvm-${llvmVersion}.src.tar.xz";
    sha256 = "0224xvfg6h40y5lrbnb9qaq3grmdc5rg00xq03s1wxjfbf8krx8z";
  };

  suitesparseVersion = "4.4.5";
  suitesparse = fetchurl {
    url = "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${suitesparseVersion}.tar.gz";
    sha256 = "1jcbxb8jx5wlcixzf6n5dca2rcfx6mlcms1k2rl5gp67ay3bix43";
  };
  version = "${majorVersion}.${minorVersion}.${maintenanceVersion}";
in

stdenv.mkDerivation rec {
  pname = "julia";
  inherit version;

  src = fetchzip {
    url = "https://github.com/JuliaLang/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = src_sha256;
  };
  prePatch = ''
    export PATH=$PATH:${cmake}/bin
    mkdir deps/srccache
    cp "${dsfmt}" "./deps/srccache/dsfmt-${dsfmtVersion}.tar.gz"
    cp "${rmath-julia}" "./deps/srccache/Rmath-julia-${rmathVersion}.tar.gz"
    cp "${libuv}" "./deps/srccache/libuv-${libuvVersion}.tar.gz"
    cp "${virtualenv}" "./deps/srccache/virtualenv-${virtualenvVersion}.tar.gz"
    cp "${libwhich}" "./deps/srccache/libwhich-${libwhichVersion}.tar.gz"
    cp "${llvm}" "./deps/srccache/llvm-${llvmVersion}.src.tar.xz"
    cp "${suitesparse}" "./deps/srccache/SuiteSparse-${suitesparseVersion}.tar.gz"
  '';

  patches = [
    ./0001.1-use-system-utf8proc.patch

    # Julia recompiles a precompiled file if the mtime stored *in* the
    # .ji file differs from the mtime of the .ji file.  This
    # doesn't work in Nix because Nix changes the mtime of files in
    # the Nix store to 1. So patch Julia to accept mtimes of 1.
    ./allow_nix_mtime.patch
  ];

  postPatch = ''
    patchShebangs . contrib
    for i in backtrace cmdlineargs; do
      mv test/$i.jl{,.off}
      touch test/$i.jl
    done
    rm stdlib/Sockets/test/runtests.jl && touch stdlib/Sockets/test/runtests.jl
    rm stdlib/Distributed/test/runtests.jl && touch stdlib/Distributed/test/runtests.jl
    sed -e 's/Invalid Content-Type:/invalid Content-Type:/g' -i ./stdlib/LibGit2/test/libgit2.jl
    sed -e 's/Failed to resolve /failed to resolve /g' -i ./stdlib/LibGit2/test/libgit2.jl
  '';

  buildInputs = [
    arpack fftw fftwSinglePrec gmp libgit2 libunwind mpfr
    pcre2.dev blas lapack openlibm openspecfun readline utf8proc
    zlib
  ]
  ++ stdenv.lib.optionals stdenv.isDarwin [CoreServices ApplicationServices]
  ;

  nativeBuildInputs = [ curl gfortran m4 makeWrapper patchelf perl python2 which ];

  makeFlags =
    let
      arch = head (splitString "-" stdenv.system);
      march = { x86_64 = stdenv.hostPlatform.platform.gcc.arch or "x86-64"; i686 = "pentium4"; }.${arch}
              or (throw "unsupported architecture: ${arch}");
      # Julia requires Pentium 4 (SSE2) or better
      cpuTarget = { x86_64 = "x86-64"; i686 = "pentium4"; }.${arch}
                  or (throw "unsupported architecture: ${arch}");
    in [
      "ARCH=${arch}"
      "MARCH=${march}"
      "JULIA_CPU_TARGET=${cpuTarget}"
      "PREFIX=$(out)"
      "prefix=$(out)"
      "SHELL=${stdenv.shell}"

      "USE_SYSTEM_BLAS=1"
      "USE_BLAS64=${if blas.isILP64 then "1" else "0"}"

      "USE_SYSTEM_LAPACK=1"

      "USE_SYSTEM_ARPACK=1"
      "USE_SYSTEM_FFTW=1"
      "USE_SYSTEM_GMP=1"
      "USE_SYSTEM_LIBGIT2=1"
      "USE_SYSTEM_LIBUNWIND=1"

      #"USE_SYSTEM_LLVM=1"
      "LLVM_VER=6.0.0"

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

  LD_LIBRARY_PATH = makeLibraryPath [
    arpack fftw fftwSinglePrec gmp libgit2 mpfr blas lapack openlibm
    openspecfun pcre2
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.isDarwin;
  checkTarget = "testall";
  # Julia's tests require read/write access to $HOME
  preCheck = ''
    export HOME="$NIX_BUILD_TOP"
  '';

  preBuild = ''
    sed -e '/^install:/s@[^ ]*/doc/[^ ]*@@' -i Makefile
    sed -e '/[$](DESTDIR)[$](docdir)/d' -i Makefile
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
  '';

  postInstall = ''
    # Symlink shared libraries from LD_LIBRARY_PATH into lib/julia,
    # as using a wrapper with LD_LIBRARY_PATH causes segmentation
    # faults when program returns an error:
    #   $ julia -e 'throw(Error())'
    find $(echo $LD_LIBRARY_PATH | sed 's|:| |g') -maxdepth 1 -name '*.${if stdenv.isDarwin then "dylib" else "so"}*' | while read lib; do
      if [[ ! -e $out/lib/julia/$(basename $lib) ]]; then
        ln -sv $lib $out/lib/julia/$(basename $lib)
      fi
    done
  '';

  passthru = {
    inherit majorVersion minorVersion maintenanceVersion;
    site = "share/julia/site/v${majorVersion}.${minorVersion}";
  };

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin rob garrison ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isi686;
  };
}
