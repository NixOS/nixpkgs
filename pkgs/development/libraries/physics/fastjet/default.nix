{ lib, stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  pname = "fastjet";
  version = "3.4.0";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    hash = "sha256-7gfIdHyOrYbYjeSp5OjR6efXYUlz9WMbqCl/egJHi5E=";
  };

  buildInputs = [ python2 ];

  configureFlags = [
    "--enable-allcxxplugins"
    "--enable-pyext"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "A software package for jet finding in pp and e+e− collisions";
    license     = lib.licenses.gpl2Plus;
    homepage    = "http://fastjet.fr/";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
