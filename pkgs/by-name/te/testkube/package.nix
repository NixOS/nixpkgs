{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "2.1.164";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    hash = "sha256-GBQDVzloAWROD7xM26gt0+cko8hbquHf5kvxVjjFeA0=";
  };

  vendorHash = "sha256-i7GjhW9w6TEHg+PBVsQ8bOuToejiPpuOcSbXO5ffAMs=";

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
