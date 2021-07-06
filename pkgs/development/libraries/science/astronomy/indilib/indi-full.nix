{ stdenv, lib, callPackage, fetchFromGitHub, indilib }:

let
  indi-version = "1.9.1";
  indi-3rdparty-src = fetchFromGitHub {
    owner = "indilib";
    repo = "indi-3rdparty";
    rev = "v${indi-version}";
    sha256 = "sha256-F0O4WUYdUL6IjJyON/XJp78v4n5rj0unm1xTzEsEH0k=";
  };
  indi-firmware = callPackage ./indi-firmware.nix {
    version = indi-version;
    src = indi-3rdparty-src;
  };
  indi-3rdparty = callPackage ./indi-3rdparty.nix {
    version = indi-version;
    src = indi-3rdparty-src;
    withFirmware = stdenv.isx86_64;
    firmware = indi-firmware;
  };
in
callPackage ./indi-with-drivers.nix {
  pname = "indi-full";
  version = indi-version;
  extraDrivers = [
    indi-3rdparty
  ] ++ lib.optionals stdenv.isx86_64 [
    indi-firmware
  ];
}
