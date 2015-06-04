{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, zlib
, readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
, ncurses, libunistring, patchelf, openblas, arpack
, tcl, tk, xproto, libX11, git, mpfr, which
}:

with stdenv.lib;

let
  realGcc = stdenv.cc.cc;
in
stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.3.6";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "refs/tags/v${version}";
    md5 = "d28e8f428485219f756d80c011d5dd32";
    name = "julia-git-v${version}";
  };

  extraSrcs =
    let
      dsfmt_ver = "2.2";
      grisu_ver = "1.1.1";
      utf8proc_ver = "1.1.6";

      dsfmt_src = fetchurl {
        url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
        name = "dsfmt-${dsfmt_ver}.tar.gz";
        md5 = "cb61be3be7254eae39684612c524740d";
      };
      grisu_src = fetchurl {
        url = "http://double-conversion.googlecode.com/files/double-conversion-${grisu_ver}.tar.gz";
        md5 = "29b533ed4311161267bff1a9a97e2953";
      };
      utf8proc_src = fetchurl {
        url = "http://www.public-software-group.org/pub/projects/utf8proc/v${utf8proc_ver}/utf8proc-v${utf8proc_ver}.tar.gz";
        md5 = "2462346301fac2994c34f5574d6c3ca7";
      };
    in [ dsfmt_src grisu_src utf8proc_src ];

  buildInputs =
    [
      gfortran perl m4 gmp pcre llvm readline zlib
      fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
      arpack openblas tcl tk xproto libX11 git mpfr which
    ];

  makeFlags =
    let
      arch = head (splitString "-" stdenv.system);
      march =
        {
          "x86_64-linux" = "x86-64";
          "i686-linux" = "i686";
        }."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");
    in [
      "ARCH=${arch}"
      "MARCH=${march}"
      "JULIA_CPU_TARGET=${march}"
      "PREFIX=$(out)"
      "prefix=$(out)"
      "SHELL=${stdenv.shell}"

      "USE_SYSTEM_PATCHELF=1"

      "USE_SYSTEM_BLAS=1"
      "LIBBLAS=-lopenblas"
      "LIBBLASNAME=libopenblas"

      "USE_SYSTEM_LAPACK=1"
      "LIBLAPACK=-lopenblas"
      "LIBLAPACKNAME=libopenblas"

      "USE_SYSTEM_ARPACK=1"
    ];

  GLPK_PREFIX = "${glpk}/include";

  NIX_CFLAGS_COMPILE = [ "-fPIC" ];

  postPatch = ''
    sed -e "s@/usr/local/lib@$out/lib@g" -i deps/Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i deps/Makefile

    patchShebangs . contrib

    # ldconfig doesn't seem to ever work on NixOS; system-wide ldconfig cache
    # is probably not what we want anyway on non-NixOS
    sed -e "s@/sbin/ldconfig@true@" -i src/ccall.*
  '';

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
    "-lunistring"
    "-lz"
  ];

  configurePhase = ''
    for i in GMP LLVM PCRE READLINE FFTW LIBUNWIND SUITESPARSE GLPK ZLIB MPFR;
    do
      makeFlags="$makeFlags USE_SYSTEM_$i=1 "
    done

    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in $extraSrcs; do
      copy_kill_hash "$i" deps
    done

    export PATH="$PATH:${stdenv.cc.libc}/sbin"
  '';

  dontStrip = true;
  dontPatchELF = true;

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "testall";

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin ttuegel ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    broken = false;
  };
}
