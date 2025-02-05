{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "2.1.88";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    hash = "sha256-HHGY6tCB9e7RRnv9oK33Ys7kWpeDNHZkBk5RMKI1vLA=";
  };

  vendorHash = "sha256-Dqqelz1pgLbJX2IuYfQ1HoUYkPQhzJ5A+1+XLCzFdxo=";

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
