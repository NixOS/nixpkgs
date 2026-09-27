{
  lib,
  stdenv,
  rustPlatform,
  udevCheckHook,
  pkg-config,
  systemd,
}:

let
  cargo = lib.importTOML ./src/Cargo.toml;
in
rustPlatform.buildRustPackage {
  pname = cargo.package.name;
  version = cargo.package.version;

  src = ./src;

  cargoLock.lockFile = ./src/Cargo.lock;

  nativeBuildInputs = [
    udevCheckHook
    pkg-config
  ];
  buildInputs = [ systemd ];
  doInstallCheck = true;
  dontCargoInstall = true;

  RUSTC_BOOTSTRAP = true;

  installFlags = [
    "DESTDIR=$(out)"
    "CARGO_RELEASE_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}/$(cargoBuildType)"
    "LOSETUP_BIN=${lib.getExe' systemd.util-linux "losetup"}"
  ];

  meta = {
    description = "Userspace implementation of the Ventoy Compatible protocol.";
    maintainers = [ lib.maintainers.elvishjerricco ];
  };
}
