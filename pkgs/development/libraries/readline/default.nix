{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "readline-5.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cwru.edu/pub/bash/readline-5.0.tar.gz ;
    md5 = "9a39d15f1ed592883f8c6671e8c13120";
  };
  inherit ncurses;
  buildInputs = [ncurses];
}
