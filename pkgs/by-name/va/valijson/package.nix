{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valijson";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-izuP8lkHv35qHbc2FIvrBgumcOyh+b3C1b8LyFst6y4=";
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
