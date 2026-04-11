{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  cpp-utilities,
  zlib,
  isocodes,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tagparser";
  version = "12.5.2";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "tagparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QVeEwQFXr2xYKFtrrWumMoo3sVRtCWCVZvwK71BgoSg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cpp-utilities
    zlib
  ];

  cmakeFlags = [
    "-DLANGUAGE_FILE_ISO_639_2=${isocodes}/share/iso-codes/json/iso_639-2.json"
  ];

  meta = {
    homepage = "https://github.com/Martchus/tagparser";
    description = "C++ library for reading and writing MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska tags";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = lib.platforms.all;
  };
})
