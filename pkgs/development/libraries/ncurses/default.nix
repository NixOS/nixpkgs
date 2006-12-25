{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ncurses-5.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/ncurses/ncurses-5.6.tar.gz;
    md5 = "b6593abe1089d6aab1551c105c9300e3";
  };
}
