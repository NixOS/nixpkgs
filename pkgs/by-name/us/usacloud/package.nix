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
  version = "1.22.4";

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = "usacloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w42+51Pfveclrp8eOfa5XuuDbH8Bx68blOU1dmyJPIw=";
  };

  vendorHash = "sha256-5hMDkGvbm6x34HrhyNs2ycgNm9nW6nOIKJtKLMura0g=";

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
