{ stdenv, fetchFromGitHub }:
platform:
assert platform.isXtensa;
let
  src = fetchFromGitHub {
    owner = "espressif";
    repo = "xtensa-overlays";
    rev = "eb39108196b775b0544c65697e63899df2cf1bfd";
    sha256 = "06335yf4z1j9vlmhkz1jf7np1rbfzinlzr5y1rsqagpa52a4kmfg";
  };
in
  "${src}/xtensa_${platform.parsed.cpu.name}"
