{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, zlib
, readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
, ncurses, libunistring, patchelf, openblas
, tcl, tk, xproto, libX11, git, mpfr, which
}:

with stdenv.lib;

let
  realGcc = stdenv.cc.cc;
  arch = head (splitString "-" stdenv.system);
  march =
    {
      "x86_64-linux" = "x86-64";
      "i686-linux" = "i686";
    }."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");

  dsfmt_ver = "2.2";
  grisu_ver = "1.1.1";
  arpack_ver = "3.1.5";
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
  arpack_src = fetchurl rec {
    url = "https://github.com/opencollab/arpack-ng/archive/${arpack_ver}.tar.gz";
    md5 = "d84e1b6108d9ee67c0d21aba7099e953";
    name = "arpack-ng-${arpack_ver}.tar.gz";
  };
  utf8proc_src = fetchurl {
    url = "http://www.public-software-group.org/pub/projects/utf8proc/v${utf8proc_ver}/utf8proc-v${utf8proc_ver}.tar.gz";
    md5 = "2462346301fac2994c34f5574d6c3ca7";
  };
in
stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.3.6";
  name = "${pname}-${version}";

  extraSrcs = [ dsfmt_src grisu_src arpack_src utf8proc_src ];

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "refs/tags/v${version}";
    md5 = "d28e8f428485219f756d80c011d5dd32";
    name = "julia-git-v${version}";
  };

  buildInputs =
    [
      gfortran perl m4 gmp pcre llvm readline zlib
      fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
      openblas tcl tk xproto libX11 git mpfr which
    ];

  makeFlags =
    [
      "USE_SYSTEM_PATCHELF=1"
      "USE_SYSTEM_OPENBLAS=1"
      "USE_SYSTEM_BLAS=1"
      "USE_SYSTEM_LAPACK=1"
      "ARCH=${arch}"
      "MARCH=${march}"
      "JULIA_CPU_TARGET=${march}"
      "PREFIX=$(out)"
      "prefix=$(out)"
      "SHELL=${stdenv.shell}"
    ];

  GLPK_PREFIX = "${glpk}/include";

  NIX_CFLAGS_COMPILE = [ "-fPIC" ];
  NIX_LDFLAGS =
    optionals
      (realGcc != null)
      [
        "-L${realGcc}/lib"
        "-L${realGcc}/lib64"
        "-lpcre" "-lm" "-lfftw3f" "-lfftw3" "-lglpk"
        "-lunistring" "-lz" "-lgmp" "-lmpfr" "-lopenblas"
      ];

  postPatch = ''
    sed -e "s@/usr/local/lib@$out/lib@g" -i deps/Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i deps/Makefile

    patchShebangs . contrib

    # ldconfig doesn't seem to ever work on NixOS; system-wide ldconfig cache
    # is probably not what we want anyway on non-NixOS
    sed -e "s@/sbin/ldconfig@true@" -i src/ccall.*
  '';

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

    ${if realGcc ==null then "" else ''export NIX_LDFLAGS="$NIX_LDFLAGS -L$out/lib"''}

    export LDFLAGS="-L${suitesparse}/lib -L$out/lib/julia -Wl,-rpath,$out/lib/julia"

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PWD/usr/lib:$PWD/usr/lib/julia"

    export PATH="$PATH:${stdenv.cc.libc}/sbin"
  '';

  preBuild = ''
    mkdir -p "$out/lib"
    ln -s "${openblas}/lib/libopenblas.so" "$out/lib/libblas.so"
    ln -s "${openblas}/lib/libopenblas.so" "$out/lib/liblapack.so"

    mkdir -p usr/lib

    echo "$out"
    mkdir -p "$out/lib"
    (
    cd "$(mktemp -d)"
    for i in "${suitesparse}"/lib/lib*.a; do
      ar -x $i
    done
    gcc *.o --shared -o "$out/lib/libsuitesparse.so"
    )
    cp "$out/lib/libsuitesparse.so" usr/lib
    for i in umfpack cholmod amd camd colamd spqr; do
      ln -s libsuitesparse.so "$out"/lib/lib$i.so;
      ln -s libsuitesparse.so "usr"/lib/lib$i.so;
    done
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
