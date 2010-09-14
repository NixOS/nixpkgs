{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name = "libdiscid-0.2.2";

  buildInputs = [ cmake ];

  src = fetchurl {
    url = "http://users.musicbrainz.org/~matt/${name}.tar.gz";
    sha256 = "00l4ln9rk0vqf67iccwqrgc9qx1al92i05zylh85kd1zn9d5sjwp";
  };

  meta = {
    description = "A C library for creating MusicBrainz DiscIDs from audio CDs";
    homepage = http://musicbrainz.org/doc/libdiscid;
    license = "LGPL-2.1";
  };
}
