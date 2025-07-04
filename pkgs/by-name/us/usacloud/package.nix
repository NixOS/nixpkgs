{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "usacloud";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = "usacloud";
    tag = "v${version}";
    hash = "sha256-HrcUoRqjbP6E/C9PfFYw73XaA5ysNLYqsiifXVnlhe0=";
  };

  vendorHash = "sha256-OIS0QV0t4Y06/B8L48IlftWjzahptaa0PAcxEcRdDPo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sacloud/usacloud/pkg/version.Revision=${src.rev}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI client for the Sakura Cloud";
    homepage = "https://github.com/sacloud/usacloud";
    changelog = "https://github.com/sacloud/usacloud/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "usacloud";
  };
}
