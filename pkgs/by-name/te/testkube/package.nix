{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.5.7";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "${finalAttrs.version}";
    hash = "sha256-5Fc/esXmwTMS929k6HXhmzGGlGaCWp/dKQUZm+kIz7M=";
  };

  vendorHash = "sha256-e2lyJdD3j87494S6oif2/OnjzRY8AEiLZxd9KeMO7UE=";

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
