{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  testers,
  installShellFiles,
  pkg-config,
  openssl,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  python3,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-riGqVAimpaAPRK281JFRJxxlneQKjT/0zvqK0vMNIWM=";
  };

  cargoHash = "sha256-hWewiXx5+wL2DNPi+9nUJ5IXHzg1mxass2ASSnTEKk0=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-MxSZAqeM452Y6HjeApIaxTPg0fvl8LbMvILbbTQeb7A=";
  };
  pnpmRoot = "ui";

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    nodejs
    pnpmConfigHook
    pnpm
    python3
  ];

  env = {
    CXXFLAGS = "-std=c++20";
    OPENSSL_NO_VENDOR = true;
  };

  preBuild = ''
    pushd ui
    pnpm build
    popd
  '';

  checkFlags = [
    # Skip tests requiring network
    "--skip=test_cli_interface"
    "--skip=fail_on_default_is_violation"
    "--skip=fail_on_improvement_exits_one_for_violation_input"
    "--skip=fail_on_information_exits_one_for_violation_input"
    "--skip=fail_on_invalid_value_is_rejected"
    "--skip=fail_on_none_exits_zero"
    "--skip=fail_on_violation_exits_one"
    "--skip=no_stats_with_none_threshold_is_silent_and_exits_zero"
    "--skip=no_stats_with_violation_threshold_warns_and_exits_zero"
  ];

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
