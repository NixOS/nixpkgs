{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  name = "uefisettings";
  version = "0-unstable-2024-03-26";

  src = fetchFromGitHub {
    owner = "linuxboot";
    repo = "uefisettings";
    rev = "f90aed759b9c2217bea336e37ab5282616ece390";
    hash = "sha256-Cik8uVdzhMmgXfx23axkUJBg8zd5afMgYvluN0BJsdo=";
  };

  useFetchCargoVendor = true;
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
