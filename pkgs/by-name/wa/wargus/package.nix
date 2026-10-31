{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  makeWrapper,
  zlib,
  bzip2,
  libpng,
  ffmpeg,
  innoextract,
  cdparanoia,
  kdePackages,
}:
let
  stratagus = callPackage ./stratagus.nix { };
in
stdenv.mkDerivation rec {
  pname = "wargus";
  inherit (stratagus) version;

  src = fetchFromGitHub {
    owner = "wargus";
    repo = "wargus";
    tag = "v${version}";
    sha256 = "sha256-rU2uMhk7Hx9hrLR/iH2tHkJ2z4cVmJB3ISlvY6dfQKU=";
  };
  patches = [
    (fetchpatch {
      # "change to cmake_minimum_required(VERSION 3.5) to fix CI"
      url = "https://github.com/Wargus/wargus/commit/e89e121edadaf3ab365263c68b5baec305a5c65f.patch";
      sha256 = "sha256-9FgflNyqZUrBY1prOahicnjslMxxUrK2bLspfGeZ6Os=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    zlib
    bzip2
    libpng
  ];

  cmakeFlags = [
    "-DSTRATAGUS=${stratagus}/games/stratagus"
    "-DSTRATAGUS_INCLUDE_DIR=${stratagus}/include/stratagus/gameheaders"
  ];
  postInstall = ''
    makeWrapper $out/games/wargus $out/bin/wargus \
      --prefix PATH : ${
        lib.makeBinPath [
          "$out"
          cdparanoia
          ffmpeg
          innoextract
          kdePackages.kdialog
        ]
      }
    substituteInPlace $out/share/applications/wargus.desktop \
      --replace $out/games/wargus $out/bin/wargus
  '';

  meta = {
    description = "Importer and scripts for Warcraft II: Tides of Darkness, the expansion Beyond the Dark Portal, and Aleonas Tales";
    homepage = "https://wargus.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.astro ];
    platforms = lib.platforms.linux;
  };
}
