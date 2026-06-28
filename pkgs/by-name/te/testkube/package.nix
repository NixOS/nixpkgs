{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "testkube";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "${finalAttrs.version}";
    hash = "sha256-h3GmswkQYqG7Xz4/X2gvIH0sAhtEfjOHf1QQumJSb5w=";
  };

  vendorHash = "sha256-LQ6K35R3NGMq4KwceuVcyfI4Q3AHImJuCifZ7hw319k=";

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
