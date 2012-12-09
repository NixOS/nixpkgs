{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, zlib
 , readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
 , ncurses, libunistring, lighttpd, patchelf, openblas, liblapack
 , tcl, tk, xproto, libX11
 } :
let
  realGcc = stdenv.gcc.gcc;
in
stdenv.mkDerivation rec {
  pname = "julia";
  date = "20121209";
  name = "${pname}-git-${date}";

  grisu_ver = "1.1.1";
  dsfmt_ver = "2.2";
  openblas_ver = "v0.2.2";
  lapack_ver = "3.4.1";
  arpack_ver = "3.1.2";
  clp_ver = "1.14.5";
  lighttpd_ver = "1.4.29";
  patchelf_ver = "0.6";

  grisu_src = fetchurl {
    url = "http://double-conversion.googlecode.com/files/double-conversion-${grisu_ver}.tar.gz";
    sha256 = "e1cabb73fd69e74f145aea91100cde483aef8b79dc730fcda0a34466730d4d1d";
  };
  dsfmt_src = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
    name = "dsfmt-${dsfmt_ver}.tar.gz";
    sha256 = "bc3947a9b2253a869fcbab8ff395416cb12958be9dba10793db2cd7e37b26899";
  };
  openblas_src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/${openblas_ver}";
    name = "openblas-${openblas_ver}.tar.gz";
    sha256 = "19ffec70f9678f5c159feadc036ca47720681b782910fbaa95aa3867e7e86d8e";
  };
  arpack_src = fetchurl {
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/497/get/";
    name = "arpack-ng_${arpack_ver}.tar.gz";
    sha256 = "1wk06bdjgap4hshx0lswzi7vxy2lrdx353y1k7yvm97mpsjvsf4k";
  };
  lapack_src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${lapack_ver}.tgz";
    name = "lapack-${lapack_ver}.tgz";
    sha256 = "93b910f94f6091a2e71b59809c4db4a14655db527cfc5821ade2e8c8ab75380f";
  };
  clp_src = fetchurl {
    url = "http://www.coin-or.org/download/source/Clp/Clp-${clp_ver}.tgz";
    name = "clp-${clp_ver}.tar.gz";
    sha256 = "e6cabe8b4319c17a9bbe6fe172194ab6cd1fe6e376f5e9969d3040636ea3a817";
  };
  lighttpd_src = fetchurl {
    url = "http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${lighttpd_ver}.tar.gz";
    sha256 = "ff9f4de3901d03bb285634c5b149191223d17f1c269a16c863bac44238119c85";
  };
  patchelf_src = fetchurl {
    url = "http://hydra.nixos.org/build/1524660/download/2/patchelf-${patchelf_ver}.tar.bz2";
    sha256 = "00bw29vdsscsili65wcb5ay0gvg1w0ljd00sb5xc6br8bylpyzpw";
  };

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "27b950f62aeb3664ab76e5d827b30b4885a9efb9";
    sha256 = "0khx8ln2zq3vpj0g66hnsdhw04hxl79fq43rc06ggsmc1j4xrifb";
  };

  buildInputs = [ gfortran perl m4 gmp pcre llvm readline zlib
    fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
    openblas liblapack tcl tk xproto libX11 
    ];

  configurePhase = ''
    for i in GMP LLVM PCRE LAPACK OPENBLAS BLAS READLINE FFTW LIBUNWIND SUITESPARSE GLPK LIGHTTPD ZLIB; 
    do 
      makeFlags="$makeFlags USE_SYSTEM_$i=1 "
    done

    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in "${grisu_src}" "${dsfmt_src}" "${arpack_src}" "${clp_src}" "${patchelf_src}" ; do
      copy_kill_hash "$i" deps
    done
    copy_kill_hash "${dsfmt_src}" deps/random

    ${if realGcc ==null then "" else 
    ''export NIX_LDFLAGS="$NIX_LDFLAGS -L${realGcc}/lib -L${realGcc}/lib64 -lpcre -llapack -lm -lfftw3f -lfftw3 -lglpk -lunistring -lz "''}
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC "

    export LDFLAGS="-L${suitesparse}/lib -L$out/lib/julia -Wl,-rpath,$out/lib/julia"

    export GLPK_PREFIX="${glpk}/include"

    mkdir -p "$out/lib"
    sed -e "s@/usr/local/lib@$out/lib@g" -i deps/Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i deps/Makefile

    export makeFlags="$makeFlags PREFIX=$out SHELL=${stdenv.shell}"

    export dontPatchELF=1

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PWD/usr/lib:$PWD/usr/lib/julia"
  '';

  preBuild = ''
    mkdir -p usr/lib
    ln -s libuv.a usr/lib/uv.a
  '';

  preInstall = ''
    make -C deps install-tk-wrapper
  '';

  postInstall = ''
   (
   cd $out/share/julia/test/ 
   $out/bin/julia runtests.jl all
   ) || true
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing.";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
