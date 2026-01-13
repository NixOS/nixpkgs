{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  rustPlatform,
  cargo,
  cmake,
  pkg-config,
  libGL,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "walksnail-osd-tool";
  version = "0.3.0"; # don't forget to update the make-build-reproducible.patch

  src = fetchFromGitHub {
    owner = "avsaase";
    repo = "walksnail-osd-tool";
    rev = "refs/tags/v${version}";
    hash = "sha256-xCrshFRsM4qUF4TffZiriNaplkjif/LeFOwLxoqtwsY=";
  };

  patches = [
    ./make-build-reproducible.patch
    ./time-crate.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ffprobe-0.3.3" = "sha256-T6ht3ZS68Hsfw+t9uGO+ZveZJtvEH3nCd+N3vh8g5HM=";
      "poll-promise-0.2.0" = "sha256-IrV0asFTu2P/FW60ft0PphFzfmkR08M/YBwUXuGVRXk=";
    };
  };

  nativeBuildInputs = [
    cargo
    cmake
    copyDesktopItems
    openssl.dev
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
  ];
  buildInputs = [
    openssl
  ];
  env = {
    OPENSSL_NO_VENDOR = 1;
    VERGEN_CARGO_TARGET_TRIPLE = "x86_64-unknown-linux-gnu";
    VERGEN_RUSTC_SEMVER = "nixos-unstable-latest";
    GIT_VERSION = "v${version}";
    GIT_COMMIT_HASH = "v${version}";
  };

  postFixup = ''
    patchelf $out/bin/.${pname}-wrapped \
              --add-rpath ${lib.makeLibraryPath [ libGL ]}
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "Walksnail OSD Tool";
    desktopName = "Walksnail OSD Tool";
    genericName = "Walksnail OSD Tool";
  };

  meta = with lib; {
    description = "Cross-platform tool for rendering the flight controller OSD and SRT data from the Walksnail Avatar HD FPV system on top of the goggle or VRX recording";
    homepage = "https://github.com/avsaase/walksnail-osd-tool";
    license = licenses.mit;
    maintainers = with maintainers; [ ilya-epifanov ];
    platforms = platforms.linux;
    mainProgram = "walksnail-osd-tool";
  };
}
