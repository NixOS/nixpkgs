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
  zstd,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hMG8GTUFLu0nFxwPAQ2HgbDXlhYIdZA5yq6W4jPQ7G4=";
  };

  cargoHash = "sha256-hoRc8tOU4o8koJ53e3oSPpN9Z3Wpn6MARrhJneis/tk=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-1HhpuY3KyFDhNY9ZNR4sr1cpa5s2JDvmXxN5TER8IXw=";
  };
  pnpmRoot = "ui";

  buildInputs = [
    openssl
    zstd
  ];

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
    "--skip=a_matcher_naming_an_unknown_signal_fails_startup"
    "--skip=a_matcher_that_applies_to_nothing_warns"
    "--skip=a_matcher_that_both_matches_and_errors_reports_only_the_error_count"
    "--skip=a_matcher_that_does_not_compile_fails_startup"
    "--skip=a_matcher_that_would_fail_on_a_sample_does_not_fail_startup"
    "--skip=a_span_that_matches_no_matcher_says_nothing_applied"
    "--skip=a_valid_matcher_does_not_change_the_run"
    "--skip=a_when_that_errors_at_runtime_warns_once_with_a_count"
    "--skip=emitting_findings_to_the_admin_port_fails_startup"
    "--skip=emitting_findings_to_the_own_listener_fails_startup"
    "--skip=the_logs_endpoint_variable_is_used_and_logged"
    "--skip=the_loop_check_sees_the_endpoint_variable"
    "--skip=the_statistics_count_what_each_matcher_matched"
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
