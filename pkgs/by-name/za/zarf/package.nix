{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "zarf-dev";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-oxqa/6FMj7Fq1chPTBIyMfsA3JqjukwvIgLc/gajXMY=";
  };

  vendorHash = "sha256-hycNgwv/hPcgZoeBDAIppT/Lg8zX/bBhWYkK78+Rams=";
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
    "github.com/zarf-dev/zarf/src/config.CLIVersion=${src.rev}"
    "-X"
    "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.rev}"
    "-X"
    "k8s.io/component-base/version.gitCommit=${src.rev}"
    "-X"
    "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export K9S_LOGS_DIR=$(mktemp -d)
    installShellCompletion --cmd zarf \
      --bash <($out/bin/zarf completion --no-log-file bash) \
      --fish <($out/bin/zarf completion --no-log-file fish) \
      --zsh  <($out/bin/zarf completion --no-log-file zsh)
  '';

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    mainProgram = "zarf";
    homepage = "https://github.com/defenseunicorns/zarf.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragingpastry ];
  };
}
