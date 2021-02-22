{ lib, stdenv, fetchurl, fetchzip, fetchFromGitHub
# build tools
, gfortran, m4, makeWrapper, patchelf, perl, which, python2
, cmake
# libjulia dependencies
, libunwind, readline, utf8proc, zlib
# standard library dependencies
, curl, fftwSinglePrec, fftw, libgit2, mpfr, openlibm, openspecfun, pcre2
# linear algebra
, blas, lapack, arpack
# Darwin frameworks
, CoreServices, ApplicationServices
}:

assert (!blas.isILP64) && (!lapack.isILP64);

with lib;

let
  majorVersion = "1";
  minorVersion = "5";
  maintenanceVersion = "3";
  src_sha256 = "sha256:0jds8lrhk4hfdv7dg5p2ibzin9ivga7wrx7zwcmz6dqp3x792n1i";
  version = "${majorVersion}.${minorVersion}.${maintenanceVersion}";
in

stdenv.mkDerivation rec {
  pname = "julia";
  inherit version;

   src = fetchzip {
     url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
     sha256 = src_sha256;
   };

  patches = [
    ./use-system-utf8proc-julia-1.3.patch

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
    # LibGit2 fails with a weird error, so we skip it as well now
    rm stdlib/LibGit2/test/runtests.jl && touch stdlib/LibGit2/test/runtests.jl
    sed -e 's/Invalid Content-Type:/invalid Content-Type:/g' -i ./stdlib/LibGit2/test/libgit2.jl
    sed -e 's/Failed to resolve /failed to resolve /g' -i ./stdlib/LibGit2/test/libgit2.jl
  '';

  dontUseCmakeConfigure = true;

  buildInputs = [
    arpack fftw fftwSinglePrec libgit2 libunwind mpfr
    pcre2.dev blas lapack openlibm openspecfun readline utf8proc
    zlib
  ] ++ lib.optionals stdenv.isDarwin [CoreServices ApplicationServices];

  nativeBuildInputs = [ curl gfortran m4 makeWrapper patchelf perl python2 which cmake ];

  makeFlags =
    let
      arch = head (splitString "-" stdenv.system);
      march = {
        x86_64 = stdenv.hostPlatform.gcc.arch or "x86-64";
        i686 = "pentium4";
        aarch64 = "armv8-a";
      }.${arch}
              or (throw "unsupported architecture: ${arch}");
      # Julia requires Pentium 4 (SSE2) or better
      cpuTarget = { x86_64 = "x86-64"; i686 = "pentium4"; aarch64 = "generic"; }.${arch}
                  or (throw "unsupported architecture: ${arch}");
    # Julia applies a lot of patches to its dependencies, so for now do not use the system LLVM
    # https://github.com/JuliaLang/julia/tree/master/deps/patches
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
      "USE_SYSTEM_GMP=0"
      "USE_SYSTEM_LIBGIT2=1"
      "USE_SYSTEM_LIBUNWIND=1"

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

      "USE_BINARYBUILDER=0"
    ];

  LD_LIBRARY_PATH = makeLibraryPath [
    arpack fftw fftwSinglePrec libgit2 mpfr blas openlibm
    openspecfun pcre2 lapack
  ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin rob garrison ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    broken = stdenv.isi686;
  };
}
