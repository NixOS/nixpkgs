{ stdenv, fetchurl, pure, pkgconfig, gsl }:

stdenv.mkDerivation rec {
  baseName = "gsl";
  version = "0.12";
  name = "pure-${baseName}-${version}";
  
  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "06bdd873d5417d90ca35093056a060b77365123ed24c3ac583cd3922d4c78a75";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure gsl ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "GNU Scientific Library interface for Pure";
    homepage = http://puredocs.bitbucket.org/pure-gsl.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
