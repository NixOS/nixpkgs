{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-7wURMdi357w5S4s909PTUZanRzFyWM588DMY7iYWP88=";
  };

  vendorHash = "sha256-umGwew8RwewlYJQD1psYSd9bu67cPEiHBJkQRJGjyGY=";

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
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  postInstall = ''
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
