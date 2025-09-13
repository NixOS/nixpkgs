{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "toml11";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "ToruNiina";
    repo = "toml11";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NnM+I43UVcd72Y9h+ysAAc7s5gZ78mjVwIMReTJ7G5M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [ "-DTOML11_BUILD_TOML_TESTS=ON" ];

  doCheck = true;

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with lib.maintainers; [ cobalt ];
    platforms = platforms.unix ++ platforms.windows;
  };
})
