{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, blas, liblapack
 , readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
 , ncurses, libunistring, lighttpd, patchelf
 } :
let
  liblapackShared = liblapack.override{shared=true;};
  realGcc = stdenv.gcc.gcc;
in
stdenv.mkDerivation rec {
  pname = "julia";
  date = "20120501";
  name = "${pname}-git-${date}";

  grisu_ver = "1.1";
  dsfmt_ver = "2.1";
  arpack_ver = "3.1.0";
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
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/376/get/";
    name = "arpack-ng_${arpack_ver}.tar.gz";
    sha256 = "65b7856126f06ecbf9ec450d50df92ca9260d4b0d21baf02497554ac230d6feb";
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
    rev = "990ffabb00f0e51d326911888facdbc473fb634d";
    sha256 = "dfcf41b2d7b62dd490bfd6f6fb962713c920de3f00afaee47423bd26eba7e3b2";
  };

  buildInputs = [ gfortran perl m4 gmp pcre llvm blas liblapackShared readline 
    fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
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
      copy_kill_hash "$i" deps
    done
    copy_kill_hash "${dsfmt_src}" deps/random

    sed -e '/cd SuiteSparse-SYSTEM/,+1s@find /lib /usr/lib /usr/local/lib@find ${suitesparse}/lib@' -i deps/Makefile

    ${if realGcc ==null then "" else 
    ''export NIX_LDFLAGS="$NIX_LDFLAGS -L${realGcc}/lib -L${realGcc}/lib64 -lpcre -llapack -lm -lfftw3f -lfftw3 -lglpk -lunistring "''}

    sed -e 's@ cpp @ gcc -E @g' -i base/Makefile

    sed -e '1s@#! */bin/bash@#!${stdenv.shell}@' -i deps/*.sh

    export LDFLAGS="-L${suitesparse}/lib"

    mkdir -p "$out/lib"
    sed -e "s@/usr/local/lib@$out/lib@g" -i deps/Makefile
    sed -e "s@/usr/lib@$out/lib@g" -i deps/Makefile
    
    sed -e '/libumfpack.a/s@find @find ${suitesparse}/lib @' -i deps/Makefile

    export makeFlags="$makeFlags PREFIX=\"$out\" USR=\"$out\""

    sed -e 's@openblas@blas@' -i base/*.jl

    sed -e '/install -v julia-release-webserver/d' -i Makefile

    export dontPatchELF=1
  '';

  postInstall = ''
   ln -s "$out/share/julia/julia" "$out/bin"

   mkdir -p "$out/share/julia/ui/"
   cp -r ui/website "$out/share/julia/ui/"
   cp deps/lighttpd.conf "$out/share/julia/ui/"

   mkdir -p "$out/share/julia/ui/webserver/"
   cp -r ui/webserver/{*.jl,*.h} "$out/share/julia/ui/webserver/"

   echo -e '#!/bin/sh' >> "$out/bin/julia-webserver"
   echo -e "cd \"$out/share/julia\"" >> "$out/bin/julia-webserver"
   echo -e '${lighttpd}/sbin/lighttpd -D -f ./ui/lighttpd.conf &' >> "$out/bin/julia-webserver"
   echo -e '../../bin/julia-release-webserver -p 2001' >> "$out/bin/julia-webserver"
   chmod a+x "$out/bin/julia-webserver"
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing.";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
