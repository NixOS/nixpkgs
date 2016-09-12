{ stdenv, fetchgit, fetchurl
# build tools
, gfortran, m4, makeWrapper, patchelf, perl, which, python2
# libjulia dependencies
, libunwind, llvm, readline, utf8proc, zlib
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
  llvmShared = if stdenv.isDarwin
               then llvm.override { enableSharedLibraries = true; }
               else llvm;
in

let
  dsfmtVersion = "2.2.3";
  dsfmt = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmtVersion}.tar.gz";
    sha256 = "03kaqbjbi6viz0n33dk5jlf6ayxqlsq4804n7kwkndiga9s4hd42";
  };

  libuvVersion = "efb40768b7c7bd9f173a7868f74b92b1c5a61a0e";
  libuv = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/libuv/tarball/${libuvVersion}";
    sha256 = "1znkxyv1cy9pjap7afypipzsn04533ni3pqjd191fdgw2sv9cal7";
  };

  rmathVersion = "0.1";
  rmath-julia = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/Rmath-julia/tarball/v${rmathVersion}";
    sha256 = "0ai5dhjc43zcvangz123ryxmlbm51s21rg13bllwyn98w67arhb4";
  };
in

stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.4.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/JuliaLang/${pname}/releases/download/v${version}/${name}.tar.gz";
    sha256 = "17wsppmsf782icyzri34zha61wfx4brfq4h68qg17w6zimd2plg5";
  };

  prePatch = ''
    cp "${dsfmt}" "./deps/dsfmt-${dsfmtVersion}.tar.gz"
    cp "${rmath-julia}" "./deps/Rmath-julia-${rmathVersion}.tar.gz"
    cp "${libuv}" "./deps/libuv-${libuvVersion}.tar.gz"
  '';

  patches = [
    ./0001-use-system-utf8proc.patch
    ./0002-use-system-suitesparse.patch
    ./0003-no-ldconfig.patch
  ];

  postPatch = ''
    patchShebangs . contrib
  '';

  buildInputs = [
    arpack fftw fftwSinglePrec gmp libgit2 libunwind llvmShared mpfr
    pcre2 openblas openlibm openspecfun readline suitesparse utf8proc
    zlib
  ] ++
    stdenv.lib.optionals stdenv.isDarwin [CoreServices ApplicationServices] ;

  nativeBuildInputs = [ curl gfortran m4 makeWrapper patchelf perl python2 which ];

  makeFlags =
    let
      arch = head (splitString "-" stdenv.system);
      march = { "x86_64" = "x86-64"; "i686" = "i686"; }."${arch}"
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

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-rpath ${llvmShared}/lib";

  dontStrip = true;
  dontPatchELF = true;

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "testall";
  # Julia's tests require read/write access to $HOME
  preCheck = ''
    export HOME="$NIX_BUILD_TOP"
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
