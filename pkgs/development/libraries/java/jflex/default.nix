{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "jflex-1.4.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://jflex.de/jflex-1.4.3.tar.gz;
    sha256 = "0sm74sgjvw01fsiqr5q9ipbm8rfyihf6yn00dqymhyc3wmbhr517";
  };
}
