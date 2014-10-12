{ stdenv, fetchurl, pure, pkgconfig, gmp, gsl, mpfr }:

stdenv.mkDerivation {
  name = "pure-gsl-0.12";
  src = fetchurl {
    url = https://bitbucket.org/purelang/pure-lang/downloads/pure-gsl-0.12.tar.gz;
    md5 = "8e90a851ff4abd9cf4bf61a0acf5ddae";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure gsl ];

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
}