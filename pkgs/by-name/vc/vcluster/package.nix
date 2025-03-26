{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  nix-update-script,
  testers,
  vcluster,
}:

buildGoModule rec {
  pname = "vcluster";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "vcluster";
    tag = "v${version}";
    hash = "sha256-zW3iqVuyuoHxOzCr5dMMO5ULqD/w5huCxmOunO5rmFw=";
  };

  vendorHash = null;

  subPackages = [ "cmd/vclusterctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  # Test is disabled because e2e tests expect k8s.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 $GOPATH/bin/vclusterctl $out/bin/vcluster

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = vcluster;
    command = "HOME=$(mktemp -d) vcluster --version";
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
