{ stdenv
, fetchFromGitHub
, cmake
, eigen
}:

stdenv.mkDerivation rec {
  pname = "opengv";
  version = "2020-08-06";
  src = fetchFromGitHub {
    owner = "laurentkneip";
    repo = "opengv";
    rev = "91f4b19c73450833a40e463ad3648aae80b3a7f3";
    sha256 = "LfnylJ9NCHlqjT76Tgku4NwxULJ+WDAcJQ2lDKGWSI4=";
  };
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    eigen
  ];
}
