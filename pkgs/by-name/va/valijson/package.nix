{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valijson";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3hQrCCDOrJx4XwTzJNTRPLghd+uoWKVDISa8rLaGiRM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Header-only C++ library for JSON Schema validation, with support for many popular parsers";
    homepage = "https://github.com/tristanpenman/valijson";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
