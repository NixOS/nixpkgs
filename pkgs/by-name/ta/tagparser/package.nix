{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  cpp-utilities,
  zlib,
  isocodes,
}:

stdenv.mkDerivation rec {
  pname = "tagparser";
  version = "12.5.2";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "tagparser";
    rev = "v${version}";
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

  meta = with lib; {
    homepage = "https://github.com/Martchus/tagparser";
    description = "C++ library for reading and writing MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska tags";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.all;
  };
}
