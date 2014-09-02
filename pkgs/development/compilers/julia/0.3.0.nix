{ stdenv, fetchgit, gfortran, perl, m4, llvm, gmp, pcre, zlib
 , readline, fftwSinglePrec, fftw, libunwind, suitesparse, glpk, fetchurl
 , ncurses, libunistring, lighttpd, patchelf, openblas, liblapack
 , tcl, tk, xproto, libX11, git, mpfr, which
 } :

assert stdenv.isLinux; 

let
  realGcc = stdenv.gcc.gcc;
in
stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.3.0";
  name = "${pname}-${version}";

  dsfmt_ver = "2.2";
  grisu_ver = "1.1.1";
  openblas_ver = "v0.2.10";
  lapack_ver = "3.5.0";
  arpack_ver = "3.1.5";
  lighttpd_ver = "1.4.29";
  patchelf_ver = "0.6";
  pcre_ver = "8.31";
  utf8proc_ver = "1.1.6";

  dsfmt_src = fetchurl {
    url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
    name = "dsfmt-${dsfmt_ver}.tar.gz";
    sha256 = "bc3947a9b2253a869fcbab8ff395416cb12958be9dba10793db2cd7e37b26899";
  };
  grisu_src = fetchurl {
    url = "http://double-conversion.googlecode.com/files/double-conversion-${grisu_ver}.tar.gz";
    sha256 = "e1cabb73fd69e74f145aea91100cde483aef8b79dc730fcda0a34466730d4d1d";
  };
  openblas_src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/${openblas_ver}";
    name = "openblas-${openblas_ver}.tar.gz";
    sha256 = "06i0q4qnd5q5xljzrgvda0gjsczc6l2pl9hw6dn2qjpw38al73za";
  };
  arpack_src = fetchurl rec {
    url = "http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/arpack-ng_${arpack_ver}.tar.gz";
    sha256 = "05fmg4m0yri47rzgsl2mnr1qbzrs7qyd557p3v9wwxxw0rwcwsd2";
  };
  lapack_src = fetchurl {
    url = "http://www.netlib.org/lapack/lapack-${lapack_ver}.tgz";
    name = "lapack-${lapack_ver}.tgz";
    sha256 = "0lk3f97i9imqascnlf6wr5mjpyxqcdj73pgj97dj2mgvyg9z1n4s";
  };
  lighttpd_src = fetchurl {
    url = "http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${lighttpd_ver}.tar.gz";
    sha256 = "ff9f4de3901d03bb285634c5b149191223d17f1c269a16c863bac44238119c85";
  };
  patchelf_src = fetchurl {
    url = "http://hydra.nixos.org/build/1524660/download/2/patchelf-${patchelf_ver}.tar.bz2";
    sha256 = "00bw29vdsscsili65wcb5ay0gvg1w0ljd00sb5xc6br8bylpyzpw";
  };
  pcre_src = fetchurl {
    url = "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${pcre_ver}.tar.bz2";
    sha256 = "0g4c0z4h30v8g8qg02zcbv7n67j5kz0ri9cfhgkpwg276ljs0y2p";
  };
  utf8proc_src = fetchurl {
    url = "http://www.public-software-group.org/pub/projects/utf8proc/v${utf8proc_ver}/utf8proc-v${utf8proc_ver}.tar.gz";
    sha256 = "1rwr84pw92ajjlbcxq0da7yxgg3ijngmrj7vhh2qzsr2h2kqzp7y";
  };

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "refs/tags/v0.3.0";
    sha256 = "1h7icqjiccw26f81r1zwsv31kk6yhavn038h7jp63iv5sdzh5r8i";
  };

  buildInputs = [ gfortran perl m4 gmp pcre llvm readline zlib
    fftw fftwSinglePrec libunwind suitesparse glpk ncurses libunistring patchelf
    openblas liblapack tcl tk xproto libX11 git mpfr which
    ];

  configurePhase = ''
    for i in GMP LLVM PCRE READLINE FFTW LIBUNWIND SUITESPARSE GLPK LIGHTTPD ZLIB MPFR;
    do
      makeFlags="$makeFlags USE_SYSTEM_$i=1 "
    done

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

    export PATH="$PATH:${stdenv.gcc.libc}/sbin"

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

  postInstall = ''
    rm -f "$out"/lib/julia/sys.{so,dylib,dll}
  '';

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms; linux;
    broken = false;
  };
}
