{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "etc-protocols-1.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/protocols;
    md5 = "6583a05c20dfb3784cd48fef2c59aa05";
  };
}
