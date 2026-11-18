{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  writableTmpDirAsHomeHook,
  stdenv,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-cli";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o9sz85CZpAuKbXqp0IUG1t11eT9DSEWPKmPg7Rg4kAY=";
  };

  vendorHash = "sha256-yuPnRMuPSAzIQCaiStlz5aZRpymZCLowgcGbglhQ4JM=";

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [
    "cmd/temporal"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/temporalio/cli/internal/temporalcli.Version=${finalAttrs.version}"
  ];

  doCheck = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd temporal \
      --bash <($out/bin/temporal completion bash) \
      --fish <($out/bin/temporal completion fish) \
      --zsh <($out/bin/temporal completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Command-line interface for running Temporal Server and interacting with Workflows, Activities, Namespaces, and other parts of Temporal";
    homepage = "https://docs.temporal.io/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aaronjheng
      jlesquembre
    ];
    mainProgram = "temporal";
  };
})
