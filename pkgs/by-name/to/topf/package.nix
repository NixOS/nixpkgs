{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "topf";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NRKRROq6uxLlAHCtpT+s+eBVjFgf8qjjwlYGhdNApUs=";
  };

  vendorHash = "sha256-9xYy1Ep7bZ0nW63fmrxiqfOrHWt7Kcn+zGhcjBpdvYY=";

  subPackages = [ "cmd/topf" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "CLI for managing Talos based Kubernetes clusters";
    longDescription = ''
      TOPF (Talos Orchestrator by PostFinance) manages Talos based
      Kubernetes clusters. It provides functionality for bootstrapping
      new clusters, resetting existing ones, and applying configuration
      changes.
    '';
    homepage = "https://github.com/postfinance/topf";
    changelog = "https://github.com/postfinance/topf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "topf";
    maintainers = with lib.maintainers; [ mdnix ];
  };
})
