{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "${finalAttrs.version}";
    hash = "sha256-rmSViKdYFNSgK5T6OyCQEiuY737S7NYqAGuR2/SHQLE=";
  };

  vendorHash = "sha256-E1Ng1bHHXnFPJg/8VwJJpceZIxdbl4TwvWTMcd3sUMk=";

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
