{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, zlib
 , readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
 , ncurses, libunistring, patchelf, openblas, liblapack
 , tcl, tk, xproto, libX11, git, mpfr, which, wget
 } :

assert stdenv.isLinux; 

let
  realGcc = stdenv.cc.gcc;
in
stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.3.5";
  name = "${pname}-${version}";

  dsfmt_ver = "2.2";
  grisu_ver = "1.1.1";
  openblas_ver = "v0.2.13";
  lapack_ver = "3.5.0";
  arpack_ver = "3.1.5";
  patchelf_ver = "0.8";
  pcre_ver = "8.36";
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
  openblas_src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/${openblas_ver}";
    name = "openblas-${openblas_ver}.tar.gz";
    md5 = "74adf4c0d0d82bff4774be5bf2134183";
  };
  arpack_src = fetchurl rec {
    url = "https://github.com/opencollab/arpack-ng/archive/${arpack_ver}.tar.gz";
    md5 = "d84e1b6108d9ee67c0d21aba7099e953";
    name = "arpack-ng-${arpack_ver}.tar.gz";
  };
  lapack_src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${lapack_ver}.tgz";
    name = "lapack-${lapack_ver}.tgz";
    md5 = "b1d3e3e425b2e44a06760ff173104bdf";
  };
  patchelf_src = fetchurl {
    url = "http://hydra.nixos.org/build/1524660/download/2/patchelf-${patchelf_ver}.tar.bz2";
    md5 = "5087261514b4b5814a39c3d3a36eb6ef";
  };
  pcre_src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${pcre_ver}.tar.bz2";
    md5 = "b767bc9af0c20bc9c1fe403b0d41ad97";
  };
  utf8proc_src = fetchurl {
    url = "http://www.public-software-group.org/pub/projects/utf8proc/v${utf8proc_ver}/utf8proc-v${utf8proc_ver}.tar.gz";
    md5 = "2462346301fac2994c34f5574d6c3ca7";
  };

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "refs/tags/v${version}";
    md5 = "abdee0e64f8e9ae3d96e37734e2db40a";
    name = "julia-git-v${version}";
  };

  buildInputs = [ gfortran perl m4 gmp pcre llvm readline zlib
    fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
    openblas liblapack tcl tk xproto libX11 git mpfr which wget
    ];

  configurePhase = ''
    for i in GMP LLVM PCRE READLINE FFTW LIBUNWIND SUITESPARSE GLPK ZLIB MPFR;
    do
      makeFlags="$makeFlags USE_SYSTEM_$i=1 "
    done
	makeFlags="$makeFlags JULIA_CPU_TARGET=core2";

    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in "${grisu_src}" "${dsfmt_src}" "${arpack_src}" "${patchelf_src}" \
        "${pcre_src}" "${utf8proc_src}" "${lapack_src}" "${openblas_src}"; do
      copy_kill_hash "$i" deps
    done

    ${if realGcc ==null then "" else 
    ''export NIX_LDFLAGS="$NIX_LDFLAGS -L${realGcc}/lib -L${realGcc}/lib64 -lpcre -llapack -lm -lfftw3f -lfftw3 -lglpk -lunistring -lz -lgmp -lmpfr -lblas -lopenblas -L$out/lib"''}
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC "

    export LDFLAGS="-L${suitesparse}/lib -L$out/lib/julia -Wl,-rpath,$out/lib/julia"

    export GLPK_PREFIX="${glpk}/include"

    mkdir -p "$out/lib"
    sed -e "s@/usr/local/lib@$out/lib@g" -i deps/Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i deps/Makefile

    export makeFlags="$makeFlags PREFIX=$out SHELL=${stdenv.shell} prefix=$out"

    export dontPatchELF=1

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PWD/usr/lib:$PWD/usr/lib/julia"

    patchShebangs . contrib

    export PATH="$PATH:${stdenv.cc.libc}/sbin"

    # ldconfig doesn't seem to ever work on NixOS; system-wide ldconfig cache
    # is probably not what we want anyway on non-NixOS
    sed -e "s@/sbin/ldconfig@true@" -i src/ccall.*

    ln -s "${openblas}/lib/libopenblas.so" "$out/lib/libblas.so"
  '';

  preBuild = ''
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

  enableParallelBuilding = true;

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
    broken = false;
  };
}
