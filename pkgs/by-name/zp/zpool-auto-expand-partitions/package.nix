{
  lib,
  rustPlatform,
  cloud-utils,
  fetchFromGitHub,
  pkg-config,
  util-linux,
  zfs,
}:
rustPlatform.buildRustPackage rec {
  pname = "zpool-auto-expand-partitions";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "zpool-auto-expand-partitions";
    rev = "v${version}";
    hash = "sha256-N1znZbJULEeNR4ABSrUtHHkmz08N+CZqX6Ni7jFzc4c=";
  };

  cargoHash = "sha256-xxTnNwqDlym4Bviek38PRUwmPKUSTnI9GOEYYyBxW+s=";

  preBuild = ''
    substituteInPlace src/grow.rs \
      --replace '"growpart"' '"${cloud-utils}/bin/growpart"'
    substituteInPlace src/lsblk.rs \
      --replace '"lsblk"' '"${util-linux}/bin/lsblk"'
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    util-linux
    zfs
  ];

  meta = with lib; {
    description = "Tool that aims to expand all partitions in a specified zpool to fill the available space";
    homepage = "https://github.com/DeterminateSystems/zpool-auto-expand-partitions";
    license = licenses.asl20;
    teams = [ teams.determinatesystems ];
    mainProgram = "zpool_part_disks";
  };
}
