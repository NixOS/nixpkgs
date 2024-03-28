{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toml11";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "ToruNiina";
    repo = "toml11";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XgpsCv38J9k8Tsq71UdZpuhaVHK3/60IQycs9CeLssA=";
  };

  patches = [
    # remove the requirement of setting CXX_STANDARD -- see https://github.com/ToruNiina/toml11/issues/241
    # (couldn't apply the commit that closed that issue because it came right after a cmake refactor,
    # so revert the commit that introduced the problematic behavior instead)
    (fetchpatch {
      name = "remove-cxx-standard-requirement.patch";
      url = "https://github.com/ToruNiina/toml11/commit/4c4e82866ecd042856b7123a83f80c0ad80a5e13.patch";
      revert = true;
      hash = "sha256-G+B4GibUvpSwosKxUa8UtQ6h3wNXAHnZySPkQoXGSTI=";
    })
  ];

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
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO [ AndersonTorres ]: tests
