{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libdiscid-0.2.2";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ];

  src = fetchurl {
    url = "http://users.musicbrainz.org/~matt/${name}.tar.gz";
    sha256 = "00l4ln9rk0vqf67iccwqrgc9qx1al92i05zylh85kd1zn9d5sjwp";
  };

  # developer forgot to update his version number
  # this is propagated to pkg-config
  preConfigure = ''
    substituteInPlace "CMakeLists.txt" \
      --replace "PROJECT_VERSION 0.1.1" "PROJECT_VERSION 0.2.2"
  '';

  meta = {
    description = "A C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = http://musicbrainz.org/doc/libdiscid;
    license = stdenv.lib.licenses.lgpl21;
  };
}
