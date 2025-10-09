{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "valijson";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v${version}";
    hash = "sha256-3hQrCCDOrJx4XwTzJNTRPLghd+uoWKVDISa8rLaGiRM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Header-only C++ library for JSON Schema validation, with support for many popular parsers";
    homepage = "https://github.com/tristanpenman/valijson";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
