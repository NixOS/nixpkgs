{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
  testers,
  vcluster,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "vcluster";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "vcluster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yGvKZ70+x+PQiTCB8MxUplymlQLm9iT+ryBHFF1a/Os=";
  };

  vendorHash = null;

  nativeBuildInputs = [
    installShellFiles
    # vcluster crashes, even on generating the completion script, if home is not writeable
    writableTmpDirAsHomeHook
  ];

  subPackages = [ "cmd/vclusterctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  # Test is disabled because e2e tests expect k8s.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 $GOPATH/bin/vclusterctl $out/bin/vcluster

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd vcluster \
      --bash <($out/bin/vcluster completion bash) \
      --fish <($out/bin/vcluster completion fish) \
      --zsh <($out/bin/vcluster completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = vcluster;
    command = "vcluster --version";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/loft-sh/vcluster/releases/tag/v${finalAttrs.version}";
    description = "Create fully functional virtual Kubernetes clusters";
    downloadPage = "https://github.com/loft-sh/vcluster";
    homepage = "https://www.vcluster.com/";
    license = lib.licenses.asl20;
    mainProgram = "vcluster";
    maintainers = with lib.maintainers; [
      qjoly
    ];
  };
})
