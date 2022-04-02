{ lib, stdenv, fetchurl, pure, pkg-config, gsl }:

stdenv.mkDerivation rec {
  pname = "pure-gsl";
  version = "0.12";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-gsl-${version}.tar.gz";
    sha256 = "06bdd873d5417d90ca35093056a060b77365123ed24c3ac583cd3922d4c78a75";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure gsl ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "GNU Scientific Library interface for Pure";
    homepage = "http://puredocs.bitbucket.org/pure-gsl.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
