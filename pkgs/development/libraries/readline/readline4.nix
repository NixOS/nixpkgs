{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "readline-4.3";
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/readline/readline-4.3.tar.gz;
    md5 = "f86f7cb717ab321fe15f1bbcb058c11e";
  };
  inherit ncurses;
  buildInputs = [ncurses];
}
