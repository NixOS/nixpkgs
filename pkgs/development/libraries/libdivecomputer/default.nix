{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdivecomputer-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "http://www.libdivecomputer.org/releases/${name}.tar.gz";
    sha256 = "11n2qpqg4b2h7mqifp9qm5gm1aqwy7wj1j4j5ha0wdjf55zzy30y";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.libdivecomputer.org;
    description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
    maintainers = [ maintainers.mguentner ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
