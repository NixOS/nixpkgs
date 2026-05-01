{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "tangara-cli";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "haileys";
    repo = "tangara-companion";
    tag = "v${version}";
    hash = "sha256-pTE+xlXWIOOt1oiKosnbXTCLYoAqP3CfXA283a//Ds0=";
  };

  cargoHash = "sha256-C7Q3Oo/aBBH6pW1zSFQ2nD07+wu8uXfRSwNif2pVlW0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
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
