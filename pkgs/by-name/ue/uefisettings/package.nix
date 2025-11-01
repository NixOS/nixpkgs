{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "uefisettings";
  version = "0-unstable-2025-07-29";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "149bc92970949d44be641ae1e3e942220d7390e7";
    hash = "sha256-n6RWqNKkfighoGpQkCWB7TEQ0lLo6cwGUBLN7lv3TrA=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  cargoHash = "sha256-CQn5esC31hCwEqZYX8OKeyJrwIKuo7x3aAZExBEcdB4=";

  checkFlags = [
    # Expects filesystem access to /proc and rootfs
    "--skip=hii::efivarfs::tests::test_get_current_mount_flags_for_proc"
    "--skip=hii::efivarfs::tests::test_get_current_mount_flags_for_root"
    # Expects FHS
    "--skip=ilorest::blobstore::Transport"
    "--skip=ilorest::chif::IloRestChif"
  ];

  meta = with lib; {
    description = "CLI tool to read/get/extract and write/change/modify BIOS/UEFI settings";
    homepage = "https://github.com/linuxboot/uefisettings";
    license = with licenses; [ bsd3 ];
    mainProgram = "uefisettings";
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
}
