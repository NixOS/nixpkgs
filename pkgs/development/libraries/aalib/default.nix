{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "aalib-1.4rc4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/aalib-1.4rc4.tar.gz;
    md5 = "d5aa8e9eae07b7441298b5c30490f6a6";
  };
  buildInputs = [ncurses];
  inherit ncurses;
}
