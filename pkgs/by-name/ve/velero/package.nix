{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "velero";
  version = "1.18.4";

  src = fetchFromGitHub {
    owner = "velero-io";
    repo = "velero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftFq6F6lHzHDHRFr5Z2t08rL8t8JhrgfedpE8GiYViY=";
  };

  ldflags = [
    "-s"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v${finalAttrs.version}"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.ImageRegistry=velero"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitTreeState=clean"
    "-X github.com/vmware-tanzu/velero/pkg/buildinfo.GitSHA=none"
  ];

  vendorHash = "sha256-mi/aiYUzyPpJIaN3XSlN+24fcpF1Lb2gtc7QBV4tyjY=";

  # test/e2e and test/perf need a cluster. pkg/controller needs envtest.
  excludedPackages = [
    "issue-template-gen"
    "release-tools"
    "v1"
    "velero-restic-restore-helper"
    "test/e2e"
    "test/perf"
    "pkg/controller"
  ];

  checkFlags = [
    "-short"
    "-skip=TestSnapshotSource" # stats /var, absent in the sandbox
  ];

  # Tests start HTTP servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/velero version --client-only | grep ${finalAttrs.version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd velero \
        --$shell <($out/bin/velero completion $shell)
    done
  '';

  meta = {
    description = "Backup and migrate Kubernetes applications and their persistent volumes";
    longDescription = ''
      Tools to back up and restore Kubernetes cluster resources and persistent
      volumes, on a public cloud or on-premises. It can also migrate resources
      between clusters and replicate a production cluster for development and
      testing.
    '';
    homepage = "https://velero.io/";
    changelog = "https://github.com/velero-io/velero/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "velero";
  };
})
