{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "usacloud";
  version = "1.22.3";

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = "usacloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vFaJBPw13YmjIzzYeAJZxnOc+nzO1Rs81xGWJqXMrL0=";
  };

  vendorHash = "sha256-5UE0JAKEcKCyQg0ksnQt8WFHZlQZRVnM0LKwwnAgfqA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sacloud/usacloud/pkg/version.Revision=${finalAttrs.src.rev}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI client for the Sakura Cloud";
    homepage = "https://github.com/sacloud/usacloud";
    changelog = "https://github.com/sacloud/usacloud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "usacloud";
  };
})
