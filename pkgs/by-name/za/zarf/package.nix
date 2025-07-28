{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "zarf-dev";
    repo = "zarf";
    tag = "v${version}";
    hash = "sha256-JjFUVUAHMweogiXivRSoIkQf6eUA2bV7bPgHxd8COEQ=";
  };

  vendorHash = "sha256-+yC7jVU6b335RsyZWjdBcjPIEO5vjhC0mJH+Rh0l3m0=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
    rm -rf hack/schema
  '';

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/zarf-dev/zarf/src/config.CLIVersion=${src.tag}"
    "-X"
    "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.tag}"
    "-X"
    "k8s.io/component-base/version.gitCommit=${src.tag}"
    "-X"
    "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export K9S_LOGS_DIR=$(mktemp -d)
    installShellCompletion --cmd zarf \
      --bash <($out/bin/zarf completion bash) \
      --fish <($out/bin/zarf completion fish) \
      --zsh  <($out/bin/zarf completion zsh)
  '';

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    mainProgram = "zarf";
    homepage = "https://zarf.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ragingpastry
    ];
  };
}
