{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  pname = "fastjet";
  version = "3.3.4";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    sha256 = "00zwvmnp2j79z95n9lgnq67q02bqfgirqla8j9y6jd8k3r052as3";
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
    homepage    = "http://fastjet.fr/";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
