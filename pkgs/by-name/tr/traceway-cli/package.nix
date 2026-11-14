{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "traceway-cli";
  version = "1.8.14";

  src = fetchFromGitHub {
    owner = "tracewayapp";
    repo = "traceway";
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-WKcHDDCz89pTeQHIXDdLYieYEwjl/SQKpg//LosVcwk=";
  };

  # The Go module and main package live in cli/ of a monorepo that also contains
  # sibling Go directories (backend/, frontend/). Confine the build to cli/ and
  # disable workspace mode so the toolchain never discovers the siblings.
  sourceRoot = "${finalAttrs.src.name}/cli";
  env.GOWORK = "off";

  # Upstream CI builds pure Go with CGO disabled.
  env.CGO_ENABLED = 0;

  vendorHash = "sha256-T+LtdUo8Cog+lECRVaRS/+ARqU6zHNXfIAc6P7n/OfE=";

  subPackages = [ "cmd/traceway" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd traceway \
      --bash <($out/bin/traceway completion bash) \
      --zsh <($out/bin/traceway completion zsh) \
      --fish <($out/bin/traceway completion fish)
  '';

  # The checkPhase tests use httptest.NewServer, which binds a loopback socket;
  # the Darwin sandbox blocks local networking by default, so allow it.
  __darwinAllowLocalNetworking = true;

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script {
    # Repo also publishes backend/v* tags; keep updates on the cli/ train.
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
