{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "readline-5.1";
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/readline/readline-5.1.tar.gz;
    md5 = "7ee5a692db88b30ca48927a13fd60e46";
  };
  propagatedBuildInputs = [ncurses];
}
