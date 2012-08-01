{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre
 , readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
 , ncurses, libunistring, lighttpd, patchelf, openblas, liblapack
 } :
let
  realGcc = stdenv.gcc.gcc;
in
stdenv.mkDerivation rec {
  pname = "julia";
  date = "20120801";
  name = "${pname}-git-${date}";

  grisu_ver = "1.1.1";
  dsfmt_ver = "2.1";
  openblas_ver = "v0.2.2";
  lapack_ver = "3.4.1";
  arpack_ver = "3.1.1";
  clp_ver = "1.14.5";
  lighttpd_ver = "1.4.29";

  grisu_src = fetchurl {
    url = "http://double-conversion.googlecode.com/files/double-conversion-${grisu_ver}.tar.gz";
    sha256 = "e1cabb73fd69e74f145aea91100cde483aef8b79dc730fcda0a34466730d4d1d";
  };
  dsfmt_src = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
    name = "dsfmt-${dsfmt_ver}.tar.gz";
    sha256 = "e9d3e04bc984ec3b14033342f5ebdcd5202d8d8e40128dd737f566945612378f";
  };
  openblas_src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/${openblas_ver}";
    name = "openblas-${openblas_ver}.tar.gz";
    sha256 = "19ffec70f9678f5c159feadc036ca47720681b782910fbaa95aa3867e7e86d8e";
  };
  arpack_src = fetchurl {
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/417/get/";
    name = "arpack-ng_${arpack_ver}.tar.gz";
    sha256 = "be250947a7d6eac7dff8c058102fce9922c524aa06be2a090b6e0bb2d1e228cd";
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

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "3b413ec24957e400c984002f7cdf6232f5391a7e";
    sha256 = "c019b724df9203899a1da5815f85d79291778191bbffc1361d2213ff7d2bbc1d";
  };

  buildInputs = [ gfortran perl m4 gmp pcre llvm readline 
    fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
    openblas liblapack
    ];

  configurePhase = ''
    for i in GMP LLVM PCRE LAPACK OPENBLAS BLAS READLINE FFTW LIBUNWIND SUITESPARSE GLPK LIGHTTPD; 
    do 
      sed -e "s@USE_SYSTEM_$i=0@USE_SYSTEM_$i=1@" -i Make.inc; 
    done
    sed -e 's@-lcurses@@g' -i Make.inc

    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in "${grisu_src}" "${dsfmt_src}" "${arpack_src}" "${clp_src}" ; do
      copy_kill_hash "$i" deps
    done
    copy_kill_hash "${dsfmt_src}" deps/random

    ${if realGcc ==null then "" else 
    ''export NIX_LDFLAGS="$NIX_LDFLAGS -L${realGcc}/lib -L${realGcc}/lib64 -lpcre -llapack -lm -lfftw3f -lfftw3 -lglpk -lunistring "''}

    sed -e 's@ cpp @ gcc -E @g' -i base/Makefile

    export LDFLAGS="-L${suitesparse}/lib"

    export GLPK_PREFIX="${glpk}/include"

    mkdir -p "$out/lib"
    sed -e "s@/usr/local/lib@$out/lib@g" -i deps/Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i deps/Makefile
    
    export makeFlags="$makeFlags PREFIX=$out" 

    export dontPatchELF=1
  '';

  preBuild = ''
    make -C test/unicode all
    make -C extras glpk_h.jl GLPK_PREFIX="$GLPK_PREFIX"
  '';

  postInstall = ''
   ld -E --whole-archive --shared ${suitesparse}/lib/lib*[a-z].a -o "$out"/lib/libsuitesparse-shared.so
   for i in umfpack cholmod amd camd colamd ; do
     ln -s "libsuitesparse-shared.so" "$out/lib/lib$i.so"
   done
   ln -s "${lighttpd}/sbin/lighttpd" "$out/sbin/"
   ln -s "${lighttpd}/lib/"* "$out/lib/"

   cp -r test examples "$out/lib/julia"
   ls -R > "$out/ls-R"
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing.";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
