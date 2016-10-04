{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "saxon-6.5.3";
  builder = ./unzip-builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/saxon/saxon6_5_3.zip;
    md5 = "7b8c7c187473c04d2abdb40d8ddab5c6";
  };

  inherit unzip;
  buildInputs = [unzip];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
