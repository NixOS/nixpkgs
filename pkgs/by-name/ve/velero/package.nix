{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "velero";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "velero";
    rev = "v${version}";
    hash = "sha256-rXWBTPM3dCGON1DvpCOsA4C4mAuVDqV9YbrvP5yDCa0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v${version}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.ImageRegistry=velero"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=none"
  ];

  vendorHash = "sha256-HpPJXYBrk5qfV01VOqXGpn4waEONJa61mqLbEsuwrEs=";

  excludedPackages = [
    "issue-template-gen"
    "release-tools"
    "v1"
    "velero-restic-restore-helper"
  ];

  doCheck = false; # Tests expect a running cluster see https://github.com/vmware-tanzu/velero/tree/main/test/e2e
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/velero version --client-only | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/velero completion bash > velero.bash
    $out/bin/velero completion zsh > velero.zsh
    installShellCompletion velero.{bash,zsh}
  '';

  meta = with lib; {
    description = "A utility for managing disaster recovery, specifically for your Kubernetes cluster resources and persistent volumes";
    homepage = "https://velero.io/";
    changelog = "https://github.com/vmware-tanzu/velero/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [
      maintainers.mbode
      maintainers.bryanasdev000
    ];
  };
}
