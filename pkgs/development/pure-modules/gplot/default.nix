{ stdenv, fetchurl, pkgconfig, pure, gnuplot }:

stdenv.mkDerivation rec {
  baseName = "gplot";
  version = "0.1";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "841ded98e4d1cdfaf78f95481e5995d0440bfda2d5df533d6741a6e7058a882c";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure gnuplot ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A pure binding to gnuplot";
    homepage = http://puredocs.bitbucket.org/pure-gplot.html;
    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
