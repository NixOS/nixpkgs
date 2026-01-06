{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "velero";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZVnYHBcnYOCBFJ9wyvMDrRIf3NyDV1Zqqf7e6JbA+go=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v${finalAttrs.version}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.ImageRegistry=velero"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=none"
  ];

  vendorHash = "sha256-AuvJmHRAmxKduP6q7k81GapGbGLS4x7cwccSnZWvPwI=";

  excludedPackages = [
    "issue-template-gen"
    "release-tools"
    "v1"
    "velero-restic-restore-helper"
  ];

  doCheck = false; # Tests expect a running cluster see https://github.com/vmware-tanzu/velero/tree/main/test/e2e
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/velero version --client-only | grep ${finalAttrs.version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/velero completion bash > velero.bash
    $out/bin/velero completion zsh > velero.zsh
    installShellCompletion velero.{bash,zsh}
  '';

  meta = {
    description = "Utility for managing disaster recovery, specifically for your Kubernetes cluster resources and persistent volumes";
    homepage = "https://velero.io/";
    changelog = "https://github.com/vmware-tanzu/velero/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mbode
    ];
  };
})
