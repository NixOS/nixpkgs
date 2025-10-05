{
  fetchFromGitHub,
  lib,
  rustPlatform,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  name = "uefisettings";
  version = "0-unstable-2024-11-28";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "f4d12fbdb32d1bc355dd37d5077add0a0a049be4";
    hash = "sha256-f6CTmnY/BzIP/nfHa3Q4HWd1Ee+b7C767FB/8A4DUUM=";
  };

  passthru.updateScript = unstableGitUpdater { };

  cargoHash = "sha256-adCC5o17j6tuffymiLUn2SEPlrjMzYn6a74/4a9HI/w=";

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
