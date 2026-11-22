{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "uefisettings";
  version = "0.1.6-unstable-2026-11-05";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "51b4472c8b6d0bcbaafe248a6fb267bd4d01ff07";
    hash = "sha256-LOx5KJIoP8NHVPq5B9QgiaiJUXjpcCkoSgcmBbgWvRE=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  cargoHash = "sha256-BBZWF069TH06J9c6imYlNEeef2hGlv0qAdIKojAdYCs=";

  checkFlags = [
    # Expects filesystem access to /proc and rootfs
    "--skip=hii::efivarfs::tests::test_get_current_mount_flags_for_proc"
    "--skip=hii::efivarfs::tests::test_get_current_mount_flags_for_root"
    # Expects FHS
    "--skip=ilorest::blobstore::Transport"
    "--skip=ilorest::chif::IloRestChif"
  ];

  meta = {
    description = "CLI tool to read/get/extract and write/change/modify BIOS/UEFI settings";
    homepage = "https://github.com/linuxboot/uefisettings";
    license = lib.licenses.bsd3;
    mainProgram = "uefisettings";
    maintainers = with lib.maintainers; [ surfaceflinger ];
    platforms = lib.platforms.linux;
  };
}
