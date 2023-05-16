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
<<<<<<< HEAD
  version = "12.1.0";
=======
  version = "11.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "tagparser";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-83Xxj1CQsghbAsQ/3GKIYCz9lBNEBvLlx1iOKbszn8A=";
=======
    hash = "sha256-zi1n5Mdto8DmUq5DWxcr4f+DX6Sq/JsK8uzRzj5f0/E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

