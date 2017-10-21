{ stdenv, fetchurl }:
        
stdenv.mkDerivation rec {
  name = "levmar-2.6";

  src = fetchurl {
    url = "http://www.ics.forth.gr/~lourakis/levmar/${name}.tgz";
    sha256 = "1mxsjip9x782z6qa6k5781wjwpvj5aczrn782m9yspa7lhgfzx1v";
  };

  patchPhase = ''
    sed -i 's/define HAVE_LAPACK/undef HAVE_LAPACK/' levmar.h
    sed -i 's/LAPACKLIBS=.*/LAPACKLIBS=/' Makefile
  '';

  installPhase = ''
    mkdir -p $out/include $out/lib
    cp lm.h $out/include
    cp liblevmar.a $out/lib
  '';

  meta = { 
    description = "ANSI C implementations of Levenberg-Marquardt, usable also from C++";
    homepage = http://www.ics.forth.gr/~lourakis/levmar/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
