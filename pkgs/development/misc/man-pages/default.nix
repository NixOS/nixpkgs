{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "man-pages-2.39";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.win.tue.nl/pub/linux-local/manpages/man-pages-2.39.tar.gz;
    md5 = "770f4e5b1a1298ed054ceae7cdbbbba4";
  };
}
