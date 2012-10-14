{ stdenv, fetchurl, cmake, neon, libdiscid }:

stdenv.mkDerivation rec {
  name = "libmusicbrainz-5.0.1";

  buildInputs = [ cmake neon libdiscid ];

  # this probably can be removed after 5.0.1: https://github.com/metabrainz/libmusicbrainz/issues/1
  dontUseCmakeBuildDir=true;

  src = fetchurl {
    url = https://github.com/downloads/metabrainz/libmusicbrainz/libmusicbrainz-5.0.1.tar.gz;
    sha256 = "1ca75e1c5059a3620b0d82633b1f468acc2a65fcc4305f844ec44f6fb5db82d5";
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
