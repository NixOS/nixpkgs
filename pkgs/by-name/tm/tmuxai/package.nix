{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tmuxai";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "alvinunreal";
    repo = "tmuxai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KMPtHiPbh/nPMLoNzmYHw/UQ29j6n8Z3HddA4B/uA6c=";
  };

  vendorHash = "sha256-9tMT84mf8XfDOn55JNtHhLa4F4Y+0j0vpn14JtICzvY=";

  ldflags = [
    "-s"
    "-X=github.com/alvinunreal/tmuxai/internal.Version=v${finalAttrs.version}"
    "-X=github.com/alvinunreal/tmuxai/internal.Commit=${finalAttrs.src.rev}"
    "-X=github.com/alvinunreal/tmuxai/internal.Date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-Powered, Non-Intrusive Terminal Assistant";
    homepage = "https://github.com/alvinunreal/tmuxai";
    changelog = "https://github.com/alvinunreal/tmuxai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "tmuxai";
  };
})
