{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "fastjet-${version}";
  version = "3.3.2";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    sha256 = "1hk3k7dyik640dzg21filpywc2dl862nl2hbpg384hf5pw9syn9z";
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
