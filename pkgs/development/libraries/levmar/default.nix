{ stdenv, fetchurl }:
        
stdenv.mkDerivation rec {
  name = "levmar-2.5";

  src = fetchurl {
    url = "http://www.ics.forth.gr/~lourakis/levmar/${name}.tgz";
    sha256 = "0xcx9fvymr0j5kmfy5cqaa2lxf1c64vv25z2a28w43pkxz1nl3xp";
  };

  patchPhase = ''
    sed -i 's/define HAVE_LAPACK/undef HAVE_LAPACK/' levmar.h
    sed -i 's/LAPACKLIBS=.*/LAPACKLIBS=/' Makefile
  '';

  installPhase = ''
    ensureDir $out/include $out/lib
    cp lm.h $out/include
    cp liblevmar.a $out/lib
  '';

  meta = { 
    description = "ANSI C implementations of Levenberg-Marquardt, usable also from C++";
    homepage = http://www.ics.forth.gr/~lourakis/levmar/;
    license = "GPLv2+";
  };
}

