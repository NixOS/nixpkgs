{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "traceway-cli";
  version = "1.7.33";

  src = fetchFromGitHub {
    owner = "tracewayapp";
    repo = "traceway";
    # Monorepo: the CLI is tagged with a slash-prefixed tag, e.g. "cli/v1.7.32"
    # (same shape as gopls's "gopls/v..." and mongodb-atlas-cli's "atlascli/v...").
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-jm32XhJ0ArSR8xCc5SlZuhBqUrEgrIsH0mN3bsIqMLM=";
  };

  # The Go module and main package live in cli/ of a monorepo that also contains
  # sibling Go directories (backend/, frontend/). Confine the build to cli/ and
  # disable workspace mode so the toolchain never discovers the siblings.
  sourceRoot = "${finalAttrs.src.name}/cli";
  env.GOWORK = "off";

  # Upstream CI builds pure Go with CGO disabled.
  env.CGO_ENABLED = 0;

  vendorHash = "sha256-T+LtdUo8Cog+lECRVaRS/+ARqU6zHNXfIAc6P7n/OfE=";

  # Build only the CLI entrypoint, relative to sourceRoot (cli/).
  subPackages = [ "cmd/traceway" ];

  # The version string is injected into `var version` in `package main`
  # (cli/cmd/traceway/version.go), so the ldflags path is the bare `main.version`.
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd traceway \
      --bash <($out/bin/traceway completion bash) \
      --zsh <($out/bin/traceway completion zsh) \
      --fish <($out/bin/traceway completion fish)
  '';

  # The checkPhase tests use httptest.NewServer, which binds a loopback socket;
  # the Darwin sandbox blocks local networking by default, so allow it.
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    # The repo mirrors both cli/* and backend/* tags; constrain updates to the
    # cli/ train so the version regex never resolves to a backend release.
    extraArgs = [ "--version-regex=cli/v([0-9.]+)" ];
  };

  meta = {
    description = "Command-line client for the Traceway observability platform";
    homepage = "https://github.com/tracewayapp/traceway";
    changelog = "https://github.com/tracewayapp/traceway/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "traceway";
    maintainers = with lib.maintainers; [ fred-drake ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
