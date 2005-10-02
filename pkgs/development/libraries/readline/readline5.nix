{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "readline-5.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/readline-5.0.tar.gz;
    md5 = "9a39d15f1ed592883f8c6671e8c13120";
  };
  inherit ncurses;
  buildInputs = [ncurses];
}
