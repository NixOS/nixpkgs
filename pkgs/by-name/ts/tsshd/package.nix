{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tsshd";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-B5PTiz9luBxkDA9UMSkGYTcPbnXdL43rkFvbOUS5F6w=";
  };

  vendorHash = "sha256-dW05EoAVLqmiPRRG0R4KwKsSijZuxSe15iHkyCImtZY=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server for `trzsz-ssh`(`tssh`) that supports connection migration for roaming";
    homepage = "https://github.com/trzsz/tsshd";
    changelog = "https://github.com/trzsz/tsshd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ljxfstorm ];
    mainProgram = "tsshd";
  };
})
