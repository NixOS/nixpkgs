{ stdenv, fetchurl, cmake, coreutils, which, libuuid, mesa, tde }:

let baseName = "tqtinterface"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "0ygxqdbqbp6kya4r425702n6z4cqfb4rra0aai8vqpcm6cz2jri9";
  };

  nativeBuildInputs = [ cmake coreutils which ];
  propagatedBuildInputs = [ mesa libuuid tde.tqt3 ];
  setupHook = ./setup-hook.sh;

  cmakeFlags = [
    "-DQT_VERSION=3"
    "-DQT_PREFIX_DIR=${tde.tqt3}"
    "-DQT_INCLUDE_DIR=${tde.tqt3}/include"
    "-DMOC_EXECUTABLE=${tde.tqt3}/bin/tqmoc" ];

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
