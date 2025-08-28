{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "tlock";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eklairs";
    repo = "tlock";
    tag = "v${version}";
    hash = "sha256-O6erxzanSO5BjMnSSmn89w9SA+xyHhp0SSDkCk5hp8Y=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-G402CigSvloF/SI9Wbcts/So1impMUH5kroxDD/KKew=";

  excludedPackages = [
    "bubbletea"
    "scripts"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/eklairs/tlock/tlock-internal/constants.VERSION=v${version}"
  ];

  meta = {
    mainProgram = "tlock";
    license = lib.licenses.mit;
    homepage = "https://github.com/eklairs/tlock";
    description = "Two-Factor Authentication Tokens Manager in Terminal";
    changelog = "https://github.com/eklairs/tlock/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ eklairs ];
    platforms = lib.platforms.unix;
  };
}
