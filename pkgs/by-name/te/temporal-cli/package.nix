{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "temporal-cli";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y/hTD31WUcVn/OBuNwdhbjDZd36EKbOJRr9PFDKHifg=";
  };

  vendorHash = "sha256-dZhrozZc3SeZQQ7lGeeICrptL2I0DH0EpsjCt4CjCJU=";

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
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "temporal";
  };
})
