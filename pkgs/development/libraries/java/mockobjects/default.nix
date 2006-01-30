{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "mockobjects-0.09";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mockobjects-bin-0.09.tar;
    md5 = "a0e11423bd5fcbb6ea65753643ea8852";
  };
}
