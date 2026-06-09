{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "trickest-cli";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "trickest";
    repo = "trickest-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AAaVwdvhQZPIXLs2ec8UtVWbcjb3CPI6V+zzkYe6KK4=";
  };

  vendorHash = "sha256-Ae0fNzYOAeCMrNFVhw4VvG/BkOMcguIMiBvLGt7wxEo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI tool to execute Trickest workflows";
    homepage = "https://github.com/trickest/trickest-cli";
    changelog = "https://github.com/trickest/trickest-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "trickest";
  };
})
