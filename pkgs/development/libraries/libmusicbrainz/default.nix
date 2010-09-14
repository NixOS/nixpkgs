{ stdenv, fetchurl, cmake, neon, libdiscid }:

stdenv.mkDerivation rec {
  name = "libmusicbrainz-3.0.2";

  buildInputs = [ cmake neon libdiscid ];

  patches = [ ./find-neon.patch ];

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${name}.tar.gz";
    sha256 = "1nhyl9kalvcn0r86y3kps6id84y3rc43226g67bssfb2h9b5x8xr";
  };
}
