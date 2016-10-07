{ stdenv, fetchurl, cmake, coreutils, which, libuuid, tqt3, mesa }:

stdenv.mkDerivation rec {

  name = "tqtinterface-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14.0";
  minorVer = "3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "14kxq7nlkalgmlxpijs78fr0zr2ha9xykzqfbr7lh3zn0r79k5a3";
  };

  buildInputs = [ cmake coreutils which ];
  propagatedBuildInputs = [ tqt3 mesa libuuid ];
  setupHook = ./setup-hook.sh;

  cmakeFlags = [
    "-DQT_VERSION=3"
    "-DQT_PREFIX_DIR=${tqt3}"
    "-DQT_INCLUDE_DIR=${tqt3}/include"
    "-DMOC_EXECUTABLE=${tqt3}/bin/tqmoc" ];

  preConfigure = ''
    cd tqtinterface
  '';

  meta = with stdenv.lib;{
    description = "A library interface for TQt";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
