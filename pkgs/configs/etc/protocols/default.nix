{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "etc-protocols-1.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/protocols.gz;
    md5 = "3c7dcc6c6d30fadec21829574116171a";
  };
}
