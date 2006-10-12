{stdenv, fetchurl, apacheAnt}:

stdenv.mkDerivation {
  name = "polyglot-dev-20060422015512";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/polyglot-dev-20060422015512.tar.gz;
    md5 = "6972fe537b4edd41872ed1cf24d24b50";
  };

  buildInputs = [apacheAnt];
}
