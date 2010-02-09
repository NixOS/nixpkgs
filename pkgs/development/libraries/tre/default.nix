{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "tre-0.8.0";
  src = fetchurl {
    url = "http://laurikari.net/tre/${name}.tar.gz";
    sha256 = "1pd7qsa7vc3ybdc6h2gr4pm9inypjysf92kab945gg4qa6jp11my";
  };

}
