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
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HlG/zBfyd120ENERqdpfPuHPwu84bWijzoE4tEOsOeE=";
  };

  vendorHash = "sha256-GI+rLSCwBRcZytbJsxqCL1+3p5/UbCvTxUHn2ele3+c=";

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

  # Tests fail with x86 on macOS Rosetta 2
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

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
