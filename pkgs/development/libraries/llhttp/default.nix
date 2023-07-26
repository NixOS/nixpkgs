{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "llhttp";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    rev = "release/v${version}";
    hash = "sha256-cXqc6/lQUhp9GV8msXsPokd6OGSczvz8uAXkM16GEE0=";
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
    changelog = "https://github.com/nodejs/llhttp/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
