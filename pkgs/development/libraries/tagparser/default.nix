{ stdenv
, lib
, fetchFromGitHub
, cmake
, cpp-utilities
, zlib
, isocodes
}:

stdenv.mkDerivation rec {
  pname = "tagparser";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "tagparser";
    rev = "v${version}";
    hash = "sha256-83Xxj1CQsghbAsQ/3GKIYCz9lBNEBvLlx1iOKbszn8A=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cpp-utilities zlib
  ];

  cmakeFlags = [
    "-DLANGUAGE_FILE_ISO_639_2=${isocodes}/share/iso-codes/json/iso_639-2.json"
  ];

  meta = with lib; {
    homepage = "https://github.com/Martchus/tagparser";
    description = "C++ library for reading and writing MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska tags";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

