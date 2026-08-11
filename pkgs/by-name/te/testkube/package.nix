{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "${finalAttrs.version}";
    hash = "sha256-CaWLM/6W0GZl6ogX4pyULUVIjs6m/ro4O8ZAjV771Pc=";
  };

  vendorHash = "sha256-fW2n64CHTIJ9dgrrgQEOcaWYdFd8UtJwrfWCa9hYR0w=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
    "-X main.commit=v${finalAttrs.version}"
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
})
