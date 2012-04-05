{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, blas, liblapack
 , readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
 , ncurses
 } :
let
  liblapackShared = liblapack.override{shared=true;};
in
stdenv.mkDerivation rec {
  pname = "julia";
  date = "20120405";
  name = "${pname}-git-${date}";

  grisu_ver = "1.1";
  dsfmt_ver = "2.1";
  arpack_ver = "3.0.2";
  clp_ver = "1.14.5";
  lighttpd_ver = "1.4.29";

  grisu_src = fetchurl {
    url = "http://double-conversion.googlecode.com/files/double-conversion-${grisu_ver}.tar.gz";
    sha256 = "addee31d11350e4dde2b19c749eda648cb0ab38a68b0dd0d0a45dc49c7346fe7";
  };
  dsfmt_src = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
    name = "dsfmt-${dsfmt_ver}.tar.gz";
    sha256 = "e9d3e04bc984ec3b14033342f5ebdcd5202d8d8e40128dd737f566945612378f";
  };
  arpack_src = fetchurl {
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/353/get/";
    name = "arpack-ng-${arpack_ver}.tar.gz";
    sha256 = "4add769386e0f6b0484491bcff129c6f5234190dbf58e07cc068fbd5dc7278bf";
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
    rev = "a6324519931e874d3691be258af7f81e4e4826e4";
    sha256 = "897019f1dc5c4ce7d1e5c607c1f9cb6efe0e6fb74184fdd921ab239c3adaed6d";
  };

  buildInputs = [ gfortran perl m4 gmp pcre llvm blas liblapackShared readline 
    fftw fftwSinglePrec libunwind suitesparse glpk ncurses
    ];

  configurePhase = ''
    for i in GMP LLVM PCRE BLAS LAPACK READLINE FFTW LIBUNWIND SUITESPARSE GLPK; 
    do 
      sed -e "s@USE_SYSTEM_$i=0@USE_SYSTEM_$i=1@" -i Make.inc; 
    done
    sed -e 's@-lcurses@@g' -i Make.inc

    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in "${grisu_src}" "${dsfmt_src}" "${arpack_src}" "${clp_src}" "${lighttpd_src}" ; do
      copy_kill_hash "$i" external
    done
    copy_kill_hash "${dsfmt_src}" external/random

    sed -e '/cd SuiteSparse-SYSTEM/,+1s@find /lib /usr/lib /usr/local/lib@find ${suitesparse}/lib@' -i external/Makefile

    export NIX_LDFLAGS="$NIX_LDFLAGS -L${stdenv.gcc.gcc}/lib -L${stdenv.gcc.gcc}/lib64 -lpcre -llapack -lm -lfftw3f -lfftw3 -lglpk "

    sed -e 's@ cpp @ gcc -E @g' -i base/Makefile
  '';

  preInstall = ''
    export makeFlags="$makeFlags PREFIX=\"$out\""
  '';

  postInstall = ''
    mkdir -p "$out/bin"
    ln -s "$out/share/julia/julia" "$out/bin"
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing.";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
