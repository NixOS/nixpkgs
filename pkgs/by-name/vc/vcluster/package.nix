{
  buildGoModule,
  fetchFromGitHub,
  go,
  installShellFiles,
  lib,
  nix-update-script,
  testers,
  vcluster,
}:

buildGoModule rec {
  pname = "vcluster";
  version = "0.19.7";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "vcluster";
    rev = "v${version}";
    hash = "sha256-sO/kpbzoAy4ohmLZ3Q7+HzoC0NoK2y0qkJ6Ib8TlEns=";
  };

  vendorHash = null;

  subPackages = [ "cmd/vclusterctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Test is disabled because e2e tests expect k8s.
  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/vclusterctl" -T $out/bin/vcluster
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
    changelog = "https://github.com/loft-sh/vcluster/releases/tag/v${version}";
    description = "Create fully functional virtual Kubernetes clusters";
    downloadPage = "https://github.com/loft-sh/vcluster";
    homepage = "https://www.vcluster.com/";
    license = lib.licenses.asl20;
    mainProgram = "vcluster";
    maintainers = with lib.maintainers; [
      berryp
      peterromfeldhk
      qjoly
    ];
  };
}
