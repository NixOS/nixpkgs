{ stdenv, fetchurl, pure, pkgconfig, gsl }:

stdenv.mkDerivation {
  name = "pure-gsl-0.12";
  src = fetchurl {
    url = https://bitbucket.org/purelang/pure-lang/downloads/pure-gsl-0.12.tar.gz;
    sha256 = "06bdd873d5417d90ca35093056a060b77365123ed24c3ac583cd3922d4c78a75";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure gsl ];

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;
}