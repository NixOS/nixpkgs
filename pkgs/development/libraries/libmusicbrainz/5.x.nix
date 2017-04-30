{ stdenv, fetchFromGitHub, cmake, neon, libdiscid, libxml2, pkgconfig }:

stdenv.mkDerivation rec {
  version = "5.1.0";
  name = "libmusicbrainz-${version}";

  buildInputs = [ cmake neon libdiscid libxml2 pkgconfig ];

  src = fetchFromGitHub {
    owner  = "metabrainz";
    repo   = "libmusicbrainz";
    sha256 = "0ah9kaf3g3iv1cps2vs1hs33nfbjfx1xscpjgxr1cg28p4ri6jhq";
    rev    = "release-${version}";
  };

  dontUseCmakeBuildDir=true;

  meta = {
    homepage = http://musicbrainz.org/doc/libmusicbrainz;
    description = "MusicBrainz Client Library (5.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
