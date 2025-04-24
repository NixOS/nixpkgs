{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  git,
}:

let
  # Convert UNIX timestamp to ISO 8601 format (Go's expected format)
  buildDate = builtins.toString builtins.currentTime;

in
buildGoModule rec {
  pname = "zarf";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "zarf-dev";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-E2kSUfMEqQjZxPQygcggt1nHZJ8OdSoehckwrTASfqQ=";
  };

  vendorHash = "sha256-W6aEFcOCtIO48UwKGDaA+t2XhtenMemMsk4nC+OzdSw=";
  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
    rm -rf hack/schema
  '';

  nativeCheckInputs = [ git ];

  checkPhase = ''
    go test -failfast $(go list ./... | grep -v '^github.com/zarf-dev/zarf/src/test' | grep -v '^github.com/zarf-dev/zarf/src/internal/packager/images' )
  '';

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/zarf-dev/zarf/src/config.CLIVersion=${src.rev}"
    "-X"
    "helm.sh/helm/v3/pkg/lint/rules.k8sVersionMajor=1"
    "-X"
    "helm.sh/helm/v3/pkg/lint/rules.k8sVersionMinor=32"
    "-X"
    "helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=1"
    "-X"
    "helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=32"
    "-X"
    "k8s.io/component-base/version.gitVersion=v1.32.3"
    "-X"
    "github.com/derailed/k9s/cmd.version=v0.40.5"
    "-X"
    "github.com/google/go-containerregistry/cmd/crane/cmd.Version=v0.20.3"
    "-X"
    "github.com/zarf-dev/zarf/src/cmd.syftVersion=v1.19.0"
    "-X"
    "github.com/zarf-dev/zarf/src/cmd.archiverVersion=v3.5.1"
    "-X"
    "github.com/zarf-dev/zarf/src/cmd.helmVersion=v3.17.1"
    "-X"
    "k8s.io/component-base/version.gitCommit=ab23aa4645f08bf237a8d4e57d21e5408f512a36"
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
    homepage = "https://github.com/zarf-dev/zarf.git";
    license = licenses.asl20;
    maintainers = with maintainers; [
      brandtkeller
      ragingpastry
    ];
  };
}
