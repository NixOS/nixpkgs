{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toml11";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "ToruNiina";
    repo = "toml11";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HnhXBvIjo1JXhp+hUQvjs83t5IBVbNN6o3ZGhB4WESQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://github.com/ToruNiina/toml11";
    description = "TOML for Modern C++";
    longDescription = ''
      toml11 is a C++11 (or later) header-only toml parser/encoder depending
      only on C++ standard library.

      - It is compatible to the latest version of TOML v1.0.0.
      - It is one of the most TOML standard compliant libraries, tested with
        the language agnostic test suite for TOML parsers by BurntSushi.
      - It shows highly informative error messages.
      - It has configurable container. You can use any random-access containers
        and key-value maps as backend containers.
      - It optionally preserves comments without any overhead.
      - It has configurable serializer that supports comments, inline tables,
        literal strings and multiline strings.
      - It supports user-defined type conversion from/into toml values.
      - It correctly handles UTF-8 sequences, with or without BOM, both on posix
        and Windows.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix ++ platforms.windows;
  };
})
