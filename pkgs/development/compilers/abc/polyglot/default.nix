{stdenv, fetchurl, apacheAnt}:

stdenv.mkDerivation {
  name = "polyglot-dev-20060319162437";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/polyglot-dev-20060319162437.tar.gz;
    md5 = "c6c29535e33f3055b7bc8f39f5acf00d";
  };

  inherit apacheAnt;
}
