{stdenv, fetchurl, apacheAnt}:

stdenv.mkDerivation {
  name = "polyglot-dev-20060422015512";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/polyglot-dev-20060422015512.tar.gz;
    md5 = "6972fe537b4edd41872ed1cf24d24b50";
  };

  buildInputs = [apacheAnt];
}
