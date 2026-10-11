{ lib
, buildNpmPackage
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, tracetest
}:

let
  pname = "tracetest";
  version = "0.15.4";
  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "tracetest";
    rev = "v${version}";
    hash = "sha256-JOzQvG/10VL8s7D1X1M/lM+QUJlY+6z6NhUIhUhEsWA=";
  };
  ui = buildNpmPackage {
    inherit pname version src;

    sourceRoot = "source/web";

    npmDepsHash = "sha256-2FhPXNyDBDvRlHawYOF3VRdp9nqacZMi01gboHCkxns=";

    npmPackFlags = [ "--ignore-scripts" ];

    env.CYPRESS_INSTALL_BINARY = 0;

    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };
in
buildGoModule rec {
  inherit pname version src;

  vendorHash = "sha256-tB2arEMG0RCGuPR4QH73wDrAIZxdD0zEvOERoM/FTrw=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cli" "server" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kubeshop/tracetest/server/version.Version=${version}"
    "-X github.com/kubeshop/tracetest/cli/version.Version=${version}"
  ];

  preBuild = ''
    cp -r ${ui} web/build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $GOPATH/bin/cli $out/bin/tracetest
    cp $GOPATH/bin/server $out/bin/tracetest-server

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd tracetest \
      --bash <($out/bin/tracetest completion bash) \
      --fish <($out/bin/tracetest completion fish) \
      --zsh <($out/bin/tracetest completion zsh)

    installShellCompletion --cmd tracetest-server \
      --bash <($out/bin/tracetest-server completion bash) \
      --fish <($out/bin/tracetest-server completion fish) \
      --zsh <($out/bin/tracetest-server completion zsh)
  '';

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      package = tracetest;
      # tracetest CLI requires server to be setup
      command = "tracetest-server version";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/kubeshop/tracetest/releases/tag/v${version}";
    description = "Build integration and end-to-end tests in minutes using OpenTelemetry and trace-based testing";
    homepage = "https://github.com/kubeshop/tracetest";
    license = licenses.mit;
    mainProgram = "tracetest";
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
