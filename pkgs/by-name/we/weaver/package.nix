{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  testers,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6rBgGU+6/EZaKkDdbRZPY+5ZS2mnUiPIPymhVpqVPX0=";
  };

  cargoHash = "sha256-9i+6xqOUUSWBPeoqgO9TpS2AkVLRB1CCZfMrPsZj8JQ=";

  checkFlags = [
    # Skip tests requiring network
    "--skip=test_cli_interface"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "OpenTelemetry tool for dealing with semantic conventions and application telemetry schemas";
    homepage = "https://github.com/open-telemetry/weaver";
    changelog = "https://github.com/open-telemetry/weaver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "weaver";
  };
})
