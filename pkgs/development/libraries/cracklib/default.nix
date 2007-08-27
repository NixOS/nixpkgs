{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cracklib-2.8.9";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/cracklib/cracklib-2.8.9.tar.gz;
    md5 = "9a8c9eb26b48787c84024ac779f64bb2";
  };
  dicts = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cracklib-words.gz;
    md5 = "d18e670e5df560a8745e1b4dede8f84f";
  };
}
