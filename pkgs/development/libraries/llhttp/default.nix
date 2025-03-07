{ lib, stdenv, fetchFromGitHub, cmake, testers, python3 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "llhttp";
  version = "9.2.1";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "llhttp";
    rev = "release/v${finalAttrs.version}";
    hash = "sha256-cnEp7Ds32bqu3jeUU/rqJOr/VW3KNmJU4pmNNaTpXRs=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_STATIC_LIBS=ON"
  ];

  passthru.tests = {
    inherit (python3.pkgs) aiohttp;

    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "libllhttp" ];
    };
  };

  meta = with lib; {
    description = "Port of http_parser to llparse";
    homepage = "https://llhttp.org/";
    changelog = "https://github.com/nodejs/llhttp/releases/tag/release/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
})
