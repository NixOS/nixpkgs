{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "whisper-cli";
  version = "0.124.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "whisper-sec";
    repo = "whisper-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fmwwGJ36nSifzjwlSOeJWOBP3gHw7c2uC0wd4/lVnXs=";
  };

  vendorHash = "sha256-q0BFXYgeD8wTXzAUB5tAEk3b5rHbG58duYqSaATacMI=";

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
