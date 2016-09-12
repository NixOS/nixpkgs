{ stdenv, fetchurl, expat }:

stdenv.mkDerivation rec {
  name = "libmusicbrainz-2.1.5";

  configureFlags = "--enable-cpp-headers";

  buildInputs = [ expat ];

  patches = [ ./gcc-4.x.patch ];

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${name}.tar.gz";
    sha256 = "183i4c109r5qx3mk4r986sx5xw4n5mdhdz4yz3rrv3s2xm5rqqn6";
  };

  meta = {
    homepage = http://musicbrainz.org/doc/libmusicbrainz;
    description = "MusicBrainz Client Library (deprecated 2.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
