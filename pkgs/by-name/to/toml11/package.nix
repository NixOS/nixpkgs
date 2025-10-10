{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toml11";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "ToruNiina";
    repo = "toml11";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NnM+I43UVcd72Y9h+ysAAc7s5gZ78mjVwIMReTJ7G5M=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "literal-operator-whitespace.patch";
      url = "https://patch-diff.githubusercontent.com/raw/ToruNiina/toml11/pull/285.patch";
      hash = "sha256-LZPr/cY6BZXC6/rBIAMCcqEdnhJs1AvbrPjpHF76uKg=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];
  cmakeFlags = [
    (lib.cmakeBool "TOML11_BUILD_TOML_TESTS" true)
  ];
  doCheck = true;

  meta = {
    changelog = "https://github.com/ToruNiina/toml11/blob/${finalAttrs.src.tag}/docs/content.en/docs/changelog/_index.md";
    homepage = "https://github.com/ToruNiina/toml11";
    description = "TOML for Modern C++";
    longDescription = ''
      toml11 is a C++11 (or later) header-only toml parser/encoder depending
      only on C++ standard library.

      - It complies with the latest TOML language specification.
      - It passes all the standard TOML language test cases.
      - It supports new features merged into the upcoming TOML version (v1.1.0).
      - It provides clear error messages, including the location of the error.
      - It parses and retains comments, associating them with corresponding values.
      - It maintains formatting information such as hex integers and considers these during serialization.
      - It provides exception-less parse function.
      - It supports complex type conversions from TOML values.
      - It allows customization of the types stored in toml::value.
      - It provides some extensions not present in the TOML language standard.
    '';
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cobalt ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
