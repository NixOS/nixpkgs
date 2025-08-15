{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    hash = "sha256-ULMN5ITyMsvRvZXK14WglP3MWNiW49pB8dmUCM2Kqqo=";
  };

  vendorHash = "sha256-6RcCkKXvHKdIKQBFAx7iFW2JZTz67zssx/gNRPttRq4=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
    "-X main.commit=v${version}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  subPackages = [ "cmd/kubectl-testkube" ];

  meta = {
    description = "Kubernetes-native framework for test definition and execution";
    homepage = "https://github.com/kubeshop/testkube/";
    license = lib.licenses.mit;
    mainProgram = "kubectl-testkube";
    maintainers = with lib.maintainers; [ mathstlouis ];
  };
}
