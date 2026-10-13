{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "uefisettings";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "bfd6e9c74719ce26a2f6c8cc5be8913b62dac3cb";
    hash = "sha256-kcVwK8kOlT/9OcL+6BBhn7wDCtrySo42BAIQu5EUP+U=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  cargoHash = "sha256-qxWC/OmHwsdLa4CefrJIJD6AEBx19zyQNrSAE+lX6uU=";

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
