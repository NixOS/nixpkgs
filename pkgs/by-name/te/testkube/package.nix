{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "${finalAttrs.version}";
    hash = "sha256-nj01nKG2uPO94xzhkRlHO0u0j9999nITTOPHVXkuKdg=";
  };

  vendorHash = "sha256-Nk/qgJNj70JIGbXDT8y2Dni12q2lI56zLYSc8TKXn0M=";

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
