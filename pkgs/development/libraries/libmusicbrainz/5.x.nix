{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  neon,
  libdiscid,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "5.1.0";
  pname = "libmusicbrainz";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    neon
    libdiscid
    libxml2
  ];

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "libmusicbrainz";
    sha256 = "0ah9kaf3g3iv1cps2vs1hs33nfbjfx1xscpjgxr1cg28p4ri6jhq";
    rev = "release-${version}";
  };

  patches = [
    # Fix build with libxml2 2.12
    (fetchpatch {
      url = "https://github.com/metabrainz/libmusicbrainz/commit/9ba00067a15479a52262a5126bcb6889da5884b7.patch";
      hash = "sha256-4VxTohLpjUNnNZGIoRpBjUz71mLP3blg4oFL7itnJnY=";
    })
    (fetchpatch {
      url = "https://github.com/metabrainz/libmusicbrainz/commit/558c9ba0e6d702d5c877f75be98176f57abf1b02.patch";
      hash = "sha256-hKYY4BJLh/Real3NugLwzc4gPBQ3NB/F63iI/aV8Wh8=";
    })
  ];

  dontUseCmakeBuildDir = true;

  meta = with lib; {
    homepage = "http://musicbrainz.org/doc/libmusicbrainz";
    description = "MusicBrainz Client Library (5.x version)";
    longDescription = ''
      The libmusicbrainz (also known as mb_client or MusicBrainz Client
      Library) is a development library geared towards developers who wish to
      add MusicBrainz lookup capabilities to their applications.'';
    platforms = platforms.all;
    license = licenses.lgpl21;
  };
}
