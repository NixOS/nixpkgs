{stdenv, fetchurl, apacheAnt, javaCup}:

stdenv.mkDerivation {
  name = "jasmin-dev-20060319162437";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/jasmin-dev-20060319162437.tar.gz;
    md5 = "d161d647ef727335cb1d15976a5e3011";
  };

  inherit apacheAnt javaCup;
}
