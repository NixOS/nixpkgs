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
  variant =
    if platform.parsed.vendor.name == "esp8266" then
      "lx106"
    else
      platform.parsed.vendor.name;
in
  "${src}/xtensa_${variant}"
