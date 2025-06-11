{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9O+INXJhNwgwwvC0751ifdHmxbD0qI5A3LdDb4Krk/o=";
  };

  vendorHash = "sha256-Xe/qrlqg6DpCNmsO/liTKjWIaY3KznkOQdXSSoJVZq4=";

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
    "-X github.com/temporalio/cli/temporalcli.Version=${finalAttrs.version}"
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
})
