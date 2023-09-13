{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "llhttp";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    rev = "release/v${finalAttrs.version}";
    hash = "sha256-DWRo9mVpmty/Ec+pKqPTZqwOlYJD+SmddwEui7P/694=";
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
    changelog = "https://github.com/nodejs/llhttp/releases/tag/release/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
})
