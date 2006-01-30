{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cracklib-2.8.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cracklib-2.8.5.tar.gz;
    md5 = "68674db41be7569099b7aa287719b248";
  };
  dicts = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cracklib-words.gz;
    md5 = "d18e670e5df560a8745e1b4dede8f84f";
  };
}
