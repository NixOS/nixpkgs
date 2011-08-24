{ stdenv, fetchurl, cmake, neon, libdiscid }:

stdenv.mkDerivation rec {
  name = "libmusicbrainz-3.0.3";

  buildInputs = [ cmake neon libdiscid ];

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${name}.tar.gz";
    md5 = "f4824d0a75bdeeef1e45cc88de7bb58a";
  };

  meta = {
    homepage = http://musicbrainz.org/doc/libmusicbrainz;
    description = "MusicBrainz Client Library (3.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
