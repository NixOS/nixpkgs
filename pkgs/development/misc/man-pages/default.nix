{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "man-pages-2.39";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/man-pages-2.39.tar.gz;
    md5 = "770f4e5b1a1298ed054ceae7cdbbbba4";
  };
}
