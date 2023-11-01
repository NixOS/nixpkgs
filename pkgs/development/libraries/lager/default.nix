{ lib
, stdenv
, fetchFromGitHub
, cmake
, sass
, boost
, immer
, zug
}:

stdenv.mkDerivation rec {
  pname = "lager";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "lager";
    rev = "v${version}";
    hash = "sha256-KTHrVV/186l4klwlcfDwFsKVoOVqWCUPzHnIbWuatbg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost immer zug ];

  cmakeFlags = [
    "-Dlager_BUILD_TESTS=OFF"
    "-Dlager_BUILD_EXAMPLES=OFF"
  ];

  meta = with lib; {
    description = "C++ library for value-oriented design using the unidirectional data-flow architecture — Redux for C++";
    homepage = "https://github.com/arximboldi/lager";
    changelog = "https://github.com/arximboldi/lager/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sifmelcara ramirez7 ];
    platforms = platforms.all;
  };
}
