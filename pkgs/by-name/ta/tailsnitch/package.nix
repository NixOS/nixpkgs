{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "tailsnitch";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "Adversis";
    repo = "tailsnitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b0++CFdOvdD99jszz6KZl7tKxGM0vAajPH9FAN8EIi0=";
  };

  vendorHash = "sha256-4K3I714F6gIG26W1Z7CpBNIGiJVg2VNfBuUbEN1+R2E=";

  ldflags = [
    "-w"
    "-s"
    "-X=github.com/Adversis/tailsnitch/cmd.Version=${finalAttrs.version}"
    "-X=github.com/Adversis/tailsnitch/cmd.BuildID=${finalAttrs.version}"
    "-X=github.com/Adversis/tailsnitch/cmd.BuildDate=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/Adversis/tailsnitch";
    changelog = "https://github.com/Adversis/tailsnitch/releases/tag/v${finalAttrs.version}";
    description = "Security auditor for Tailscale configurations. Scans your tailnet for misconfigurations, overly permissive access controls, and security best practice violations";
    mainProgram = "tailsnitch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yethal
    ];
  };
})
