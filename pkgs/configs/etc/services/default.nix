{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "etc-services-1.42";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/services;
    md5 = "dde31302b080df6ec5fcacee0d56dc90";
  };
}
