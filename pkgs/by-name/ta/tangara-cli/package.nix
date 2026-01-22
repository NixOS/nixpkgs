{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  udev,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "tangara-cli";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "haileys";
    repo = "tangara-companion";
    tag = "v${version}";
    hash = "sha256-x/xB+itr1GVcaTEre3u6Lchg9VcSzWiNyWVGv5Aczgw=";
  };

  cargoHash = "sha256-PVTfAG2AOioW1zVXtXB5SBJX2sJoWVRQO3NafUOAleo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    udev
  ];

  buildAndTestSubdir = "crates/tangara-cli";

  meta = {
    description = "Command-line tool for managing the Cool Tech Zone Tangara";
    mainProgram = "tangara";
    homepage = "https://github.com/haileys/tangara-companion";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ stevestreza ];
    platforms = lib.platforms.linux;
  };
}
