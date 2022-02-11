{ lib, stdenv, fetchurl, pkg-config, pure, gnuplot }:

stdenv.mkDerivation rec {
  pname = "pure-gplot";
  version = "0.1";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-gplot-${version}.tar.gz";
    sha256 = "841ded98e4d1cdfaf78f95481e5995d0440bfda2d5df533d6741a6e7058a882c";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure gnuplot ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A pure binding to gnuplot";
    homepage = "http://puredocs.bitbucket.org/pure-gplot.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
