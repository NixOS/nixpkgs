{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "llhttp";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    rev = "release/v${version}";
    hash = "sha256-pBGjcT5MiCSJI12TiH1XH5eAzIeylCdP/82L3o38BJo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_STATIC_LIBS=ON"
  ];

  meta = with lib; {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
