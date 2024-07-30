{ lib, stdenv, fetchurl, cmake, neon, libdiscid }:

stdenv.mkDerivation rec {
  pname = "libmusicbrainz";
  version = "3.0.3";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ neon libdiscid ];

  src = fetchurl {
    url = "ftp://ftp.musicbrainz.org/pub/musicbrainz/${pname}-${version}.tar.gz";
    sha256 = "1i9qly13bwwmgj68vma766hgvsd1m75236haqsp9zgh5znlmkm3z";
  };

  patches = [
    # Fix spacing around string literal for modern clang
    ./v3-darwin.patch
  ];

  meta = with lib; {
    homepage = "http://musicbrainz.org/doc/libmusicbrainz";
    description = "MusicBrainz Client Library (3.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
