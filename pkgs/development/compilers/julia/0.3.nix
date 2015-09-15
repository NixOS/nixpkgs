{ stdenv, fetchgit, fetchurl
# build tools
, gfortran, git, m4, patchelf, perl, which, python2
# libjulia dependencies
, libunwind, llvm, readline, utf8proc, zlib
# standard library dependencies
, double_conversion, fftwSinglePrec, fftw, glpk, gmp, mpfr, pcre
, openblas, arpack, suitesparse
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.3.11";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "refs/tags/v${version}";
    sha256 = "06xmv2l8hskdh1s5y2dh28vpb5pc0gzmfl5a03yp0qjjsl5cb284";
    name = "julia-git-v${version}";
  };

  patches = [ ./0001-work-around-buggy-wcwidth.patch ];

  extraSrcs =
    let
      dsfmt_ver = "2.2";

      dsfmt_src = fetchurl {
        url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
        name = "dsfmt-${dsfmt_ver}.tar.gz";
        md5 = "cb61be3be7254eae39684612c524740d";
      };

    in [ dsfmt_src llvm.src ];

  prePatch = ''
    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in $extraSrcs; do
      copy_kill_hash "$i" deps
    done
  '';

  postPatch = ''
    sed -i deps/Makefile \
        -e "s@/usr/local/lib@$out/lib@g" \
        -e "s@/usr/lib@$out/lib@g" \
        -e "s@/usr/include/double-conversion@${double_conversion}/include/double-conversion@g"

    patchShebangs . contrib

    # ldconfig doesn't seem to ever work on NixOS; system-wide ldconfig cache
    # is probably not what we want anyway on non-NixOS
    sed -e "s@/sbin/ldconfig@true@" -i src/ccall.*
  '';

  buildInputs =
    [ libunwind readline utf8proc zlib
      double_conversion fftw fftwSinglePrec glpk gmp mpfr pcre
      openblas arpack suitesparse
    ];

  nativeBuildInputs = [ gfortran git m4 patchelf perl which python2 ];

  makeFlags =
    [
      "PREFIX=$(out)"
      "prefix=$(out)"
      "SHELL=${stdenv.shell}"

      "USE_SYSTEM_BLAS=1"
      "LIBBLAS=-lopenblas"
      "LIBBLASNAME=libopenblas"

      "USE_SYSTEM_LAPACK=1"
      "LIBLAPACK=-lopenblas"
      "LIBLAPACKNAME=libopenblas"

      "USE_SYSTEM_ARPACK=1"
      "USE_SYSTEM_FFTW=1"
      "USE_SYSTEM_GLPK=1"
      "USE_SYSTEM_GMP=1"
      "USE_SYSTEM_GRISU=1"
      "USE_SYSTEM_LIBUNWIND=1"
      "USE_SYSTEM_MPFR=1"
      "USE_SYSTEM_PATCHELF=1"
      "USE_SYSTEM_PCRE=1"
      "USE_SYSTEM_READLINE=1"
      "USE_SYSTEM_SUITESPARSE=1"
      "USE_SYSTEM_UTF8PROC=1"
      "USE_SYSTEM_ZLIB=1"
    ];

  GLPK_PREFIX = "${glpk}/include";

  NIX_CFLAGS_COMPILE = [ "-fPIC" ];

  # Julia tries to load these libraries dynamically at runtime, but they can't be found.
  # Easier by far to link against them as usual.
  # These go in LDFLAGS, where they affect only Julia itself, and not NIX_LDFLAGS,
  # where they would also be used for all the private libraries Julia builds.
  LDFLAGS = [
    "-larpack"
    "-lfftw3_threads"
    "-lfftw3f_threads"
    "-lglpk"
    "-lgmp"
    "-lmpfr"
    "-lopenblas"
    "-lpcre"
    "-lsuitesparse"
    "-lz"
  ];

  dontStrip = true;
  dontPatchELF = true;

  enableParallelBuilding = true;

  # Test fail on i686 (julia version 0.3.10)
  doCheck = !stdenv.isi686;
  checkTarget = "testall";

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin ttuegel ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
