{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "usacloud";
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = "usacloud";
    tag = "v${version}";
    hash = "sha256-Yci2mka92covvddDehT5PkEdmaUnS2rhPn7FT3oCvks=";
  };

  vendorHash = "sha256-sSM7ZdGknhVvccKJtkwPmzwXEPRzUmxGlGojasqpul8=";

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
