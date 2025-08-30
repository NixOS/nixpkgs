{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.61.0";

  src = fetchFromGitHub {
    owner = "zarf-dev";
    repo = "zarf";
    tag = "v${version}";
    hash = "sha256-ee9RlrXCO8uXYF5ry2/aY2zyN7aWpvdHb+zq5rDN7J4=";
  };

  vendorHash = "sha256-bq45wGjtwoCNXJS5M6iyOLlI9iBJ+mPBFnBhlBHLsqc=";
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
