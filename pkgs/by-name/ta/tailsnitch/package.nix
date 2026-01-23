{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "tailsnitch";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Adversis";
    repo = "tailsnitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LvAOIDM1YIB4LmOm6zXrzr5SOH7tyF4t79XCLDg6p2Q=";
  };

  vendorHash = "sha256-khw9K4sKhubhkccoC4f923Aw2Cj9eKpVqLHZICdkTXw=";

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
