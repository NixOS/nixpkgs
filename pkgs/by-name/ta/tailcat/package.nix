{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tailcat";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EwjhZzovODhW4seO3FToPLiAV+YwVbrX/u93RfbWMZ4=";
  };

  vendorHash = "sha256-3uVUHATnd2s+Axdq06/xAQ2IbzJZfP1yQ/nEopgckq0=";

  subPackages = [ "cmd/tailcat" ];

  ldflags = [
    "-s"
    "-X main.version=v${finalAttrs.version}"
  ];

  env.CGO_ENABLED = "0";

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Like netcat, but over Tailscale's data plane, without Tailscale's control plane";
    homepage = "https://github.com/tailscale/tailcat";
    changelog = "https://github.com/tailscale/tailcat/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "tailcat";
  };
})
