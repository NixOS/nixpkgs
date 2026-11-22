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
  version = "1.22.12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sacloud";
    repo = "usacloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CiP0KhFfCZJZ8ueuePBqcK4V8Gm0i+PQZXJ9TzyB6d4=";
  };

  vendorHash = "sha256-H+SgpbuIjeAhvH4WBqMTWe+C3pucHzZW6+vJp3Dp9hg=";

  ldflags = [
    "-s"
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
