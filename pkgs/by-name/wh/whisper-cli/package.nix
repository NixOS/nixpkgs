{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "whisper-cli";
  version = "0.210.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "whisper-sec";
    repo = "whisper-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W4w8uWkAP91X/XksrLkZImlXRn5/tlegd0U1SZN4ldc=";
  };

  vendorHash = "sha256-igwMhV0vG+B6BzMWaJS1EkmigJZpKXDpi1Y06wENHn0=";

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
