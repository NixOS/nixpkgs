{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "uefisettings";
  version = "0-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "a568f5420894ec4884ffce84d8e377aaf83f0639";
    hash = "sha256-boRqHFU/UpNdFgHIoRTIlx79rMapZ8RGcuqGFNysXKI=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  cargoHash = "sha256-6aCCOyHuyp/cZXOZZnmDTcw+rB8bfcUNg/uhjEWfFPM=";

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
