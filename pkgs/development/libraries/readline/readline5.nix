{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "readline-5.2";
  src = fetchurl {
    url = mirror://gnu/readline/readline-5.2.tar.gz;
    md5 = "e39331f32ad14009b9ff49cc10c5e751";
  };
  propagatedBuildInputs = [ncurses];
}
