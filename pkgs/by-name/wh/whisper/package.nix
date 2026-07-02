{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "whisper";
  version = "0.128.0";

  src = fetchFromGitHub {
    owner = "whisper-sec";
    repo = "whisper-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wcdwr6ROEqo6Vl5eH8LQc9f3yQHSj+70A6RmoOB4Seg=";
  };

  vendorHash = "sha256-6uJxbARrRD/QaTMymqrM4PziAgH/VrWSW3BbWJabH0Q=";

  subPackages = [ "cmd/whisper" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/whisper-sec/whisper-cli/internal/cli.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Give your agent a real, routable IPv6 identity on the Whisper network";
    homepage = "https://whisper.online";
    changelog = "https://github.com/whisper-sec/whisper-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "whisper";
    maintainers = with lib.maintainers; [ kakooch ];
  };
})
