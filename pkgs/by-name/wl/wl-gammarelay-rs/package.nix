{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "wl-gammarelay-rs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wl-gammarelay-rs";
    rev = "v${version}";
    hash = "sha256-36u2s+Yv+0/lZErHonVvzyBuZ2xES2MGMG4PRjaM74k=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustbus-0.19.3" = "sha256-Eq3qCsjiNKe3Vdpx7a3J1icPGQmKfCyz1wcgCyztH64=";
      "rustbus-service-0.1.0" = "sha256-9yuIPqOecTqP0zsFqSue4hL7ZEF9MQpTF1gCJpKV6nk=";
    };
  };

  meta = {
    description = "A simple program that provides DBus interface to control display temperature and brightness under wayland without flickering";
    homepage = "https://github.com/MaxVerevkin/wl-gammarelay-rs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "wl-gammarelay-rs";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.linux;
  };
}
