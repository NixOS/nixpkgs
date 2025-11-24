{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "trickest-cli";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "trickest";
    repo = "trickest-cli";
    tag = "v${version}";
    hash = "sha256-LDroWDGTYUFtkZkooWCEL59f+iu8izUcSyqr3Jzch7o=";
  };

  vendorHash = "sha256-Ae0fNzYOAeCMrNFVhw4VvG/BkOMcguIMiBvLGt7wxEo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI tool to execute Trickest workflows";
    homepage = "https://github.com/trickest/trickest-cli";
    changelog = "https://github.com/trickest/trickest-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "trickest";
  };
}
