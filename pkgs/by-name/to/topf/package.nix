{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "topf";
  version = "0.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q9Gr1UuFOxptui6ZOhE0qTMXXVAkLjkAX0n9rzlpaOU=";
  };

  vendorHash = "sha256-TyrlEJjh3SwBaGowM+f096GM2WGfDcxW+RWqspAB7rU=";

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
