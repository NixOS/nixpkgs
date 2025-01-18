{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "2.1.84";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    hash = "sha256-1w+n/CXFWVLROSlI/bo5g9MMb1UNsqFDz8mL+5Xxg/s=";
  };

  vendorHash = "sha256-GCXbp8cJUji7vAEVpTP9T/mRIwfu5+TqEKtoOQWlxrY=";

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
