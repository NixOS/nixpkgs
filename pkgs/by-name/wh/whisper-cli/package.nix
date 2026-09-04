{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "whisper-cli";
  version = "0.211.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "whisper-sec";
    repo = "whisper-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mTq2M05ILi3aJ7yROoyZz3nx8tvqWAgG44Ty77tDsq8=";
  };

  vendorHash = "sha256-0il3bPeRFbZG8JOoM/usJtkafW4QpYxCYvW/eYX3hvo=";

  subPackages = [ "cmd/whisper" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/whisper-sec/whisper-cli/internal/cli.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Give your agent a real, routable Whisper IPv6 identity in one command";
    homepage = "https://whisper.online";
    changelog = "https://github.com/whisper-sec/whisper-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "whisper";
    maintainers = with lib.maintainers; [ kakooch ];
  };
})
