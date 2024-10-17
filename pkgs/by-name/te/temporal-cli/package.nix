{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-y0C2z2iMMQSG5+xGngZ98+ixIgbvaQxPdAWuPbEbBAY=";
  };

  vendorHash = "sha256-zhGqDHdVGg7eGnw5L3eSyXKBTjp85ir5zrtf7HbXmC0=";

  overrideModAttrs = old: {
    # https://gitlab.com/cznic/libc/-/merge_requests/10
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [
    "./cmd/docgen"
    "./tests"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/temporalio/cli/temporalcli.Version=${version}"
  ];

  # Tests fail with x86 on macOS Rosetta 2
  doCheck = !(stdenv.isDarwin && stdenv.hostPlatform.isx86_64);

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd temporal \
      --bash <($out/bin/temporal completion bash) \
      --fish <($out/bin/temporal completion fish) \
      --zsh <($out/bin/temporal completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command-line interface for running Temporal Server and interacting with Workflows, Activities, Namespaces, and other parts of Temporal";
    homepage = "https://docs.temporal.io/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "temporal";
  };
}
