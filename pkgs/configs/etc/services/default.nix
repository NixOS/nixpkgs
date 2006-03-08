{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "etc-services-1.42";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~armijn/.nix/services.gz;
    md5 = "093dbece9828e5e979081f3722858fb9";
  };
}
