{ stdenv, fetchgit, fetchurl
# build tools
, gfortran, m4, makeWrapper, patchelf, perl, which, python2
# libjulia dependencies
, libunwind, llvm, readline, utf8proc, zlib
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
  dsfmtVersion = "2.2.3";
  dsfmt = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmtVersion}.tar.gz";
    sha256 = "03kaqbjbi6viz0n33dk5jlf6ayxqlsq4804n7kwkndiga9s4hd42";
  };

  libuvVersion = "07730c4bd595b4d45a498a8ee0bcd53878ff7c10";
  libuv = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/libuv/tarball/${libuvVersion}";
    sha256 = "19nk8vdvx2mxyrwpndb7888c3b237ja5xvxr3jk5ah77ix3srr3h";
  };

  rmathVersion = "0.1";
  rmath-julia = fetchurl {
    url = "https://api.github.com/repos/JuliaLang/Rmath-julia/tarball/v${rmathVersion}";
    sha256 = "0ai5dhjc43zcvangz123ryxmlbm51s21rg13bllwyn98w67arhb4";
  };
  
  virtualenvVersion = "1.11.6";
  virtualenv = fetchurl {
    url = "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-${virtualenvVersion}.tar.gz";
    sha256 = "1xq4prmg25n9cz5zcvbqx68lmc3kl39by582vd8pzs9f3qalqyiy";
  };
in

stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.4.4-pre-2016-02-08";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://github.com/JuliaLang/${pname}";
    rev = "cb93e6b70b4b1313b4de8c54e55e85c8eb43daa3";
    sha256 = "11dmbjqiidlbh8sj5s09zsbfslm3zs0kw7iq40281hl5dfsr7zm6";
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
  ];

  postPatch = ''
    patchShebangs . contrib
  '';

  buildInputs = [
    arpack fftw fftwSinglePrec gmp libgit2 libunwind llvm mpfr
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

  LD_LIBRARY_PATH = makeSearchPath "lib" (concatLists (map (x : x.all) [
    arpack fftw fftwSinglePrec gmp libgit2 mpfr openblas openlibm
    openspecfun pcre2 suitesparse
  ]));

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
            --prefix PATH : "${curl}/bin"
    done
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin ttuegel ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
