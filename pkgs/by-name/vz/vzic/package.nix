{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  glib,
  tzdata,
  libical,
}:
stdenv.mkDerivation rec {
  pname = "vzic";
  version = "tzdata2024a";

  src = fetchFromGitHub {
    owner = "libical";
    repo = "vzic";
    rev = "4a87e2bed237585cbcf209507d0b82c023113633";
    hash = "sha256-zRy62SJa8XUBPnoW/fgANKZaatNWqmXka4LgRUlbLzw=";
  };

  nativeBuildInputs = [
    pkg-config
    tzdata
    glib
    libical
  ];
  OLSON_DIR = version;
  PRODUCT_ID = "-//NixOS//NONSGML Citadel calendar//EN";
  TZID_PREFIX = "/NixOS/Olson_%D_1/";

  installPhase = ''
    mkdir -p $out/share/vtimezone $out/bin
    ./vzic --output-dir $out/share/vtimezone
    mv vzic $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/libical/vzic";
    description = "A program to convert the IANA timezone database files into VTIMEZONE files compatible with the iCalendar specification";
    mainProgram = "vzic";
    platforms = platforms.unix;
  };
}
