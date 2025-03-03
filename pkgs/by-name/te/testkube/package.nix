{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "testkube";
  version = "2.1.101";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "testkube";
    rev = "v${version}";
    hash = "sha256-caeBDdfjrvGHVZdMxy8OXN5SidCL3z2AJ7LuACWwJ+g=";
  };

  vendorHash = "sha256-qAer8XBs8vqRLT6sqYtT3uS2ocFs3VLt7HZ5mKg4qUg=";

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
