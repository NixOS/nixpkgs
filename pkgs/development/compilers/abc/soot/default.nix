{stdenv, fetchurl, apacheAnt, polyglot, jasmin}:

stdenv.mkDerivation {
  name = "soot-dev-20060319162437";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/soot-dev-20060319162437.tar.gz;
    md5 = "5657edcb5de974514f151aca37112630";
  };

  inherit apacheAnt polyglot jasmin;
}
