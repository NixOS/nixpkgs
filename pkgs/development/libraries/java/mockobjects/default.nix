{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "mockobjects-0.09";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://sourceforge/mockobjects/mockobjects-bin-0.09.tar;
    md5 = "a0e11423bd5fcbb6ea65753643ea8852";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
