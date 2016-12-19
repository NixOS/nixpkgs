{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fastjet-${version}";
  version = "3.2.0";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    sha256 = "1qvmab7l4ps5xd1wvmblgpzyhkbs2gff41qgyg7r7b9nlgqjgacn";
  };

  configureFlags = "--enable-allcxxplugins";

  enableParallelBuilding = true;

  meta = {
    description = "A software package for jet finding in pp and e+e− collisions";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = http://fastjet.fr/;
    platforms   = stdenv.lib.platforms.unix;
  };
}
