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

<<<<<<< HEAD
  meta = {
    description = "Tool that aims to expand all partitions in a specified zpool to fill the available space";
    homepage = "https://github.com/DeterminateSystems/zpool-auto-expand-partitions";
    license = lib.licenses.asl20;
    teams = [ lib.teams.determinatesystems ];
=======
  meta = with lib; {
    description = "Tool that aims to expand all partitions in a specified zpool to fill the available space";
    homepage = "https://github.com/DeterminateSystems/zpool-auto-expand-partitions";
    license = licenses.asl20;
    teams = [ teams.determinatesystems ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "zpool_part_disks";
  };
}
