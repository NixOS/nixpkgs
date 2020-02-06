{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  pname = "fastjet";
  version = "3.3.3";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    sha256 = "0avkgn19plq593p872hirr0yj2vgjvsi88w68ngarbp55hla1c1h";
  };

  buildInputs = [ python2 ];

  configureFlags = [
    "--enable-allcxxplugins"
    "--enable-pyext"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "A software package for jet finding in pp and e+e− collisions";
    license     = stdenv.lib.licenses.gpl2Plus;
    homepage    = http://fastjet.fr/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
