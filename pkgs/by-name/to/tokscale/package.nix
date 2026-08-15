{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tokscale";
  version = "4.13.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "junhoyeo";
    repo = "tokscale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0BQnoIDETgh6S806mHvxqDBpcJJQZbhl46yj6ctUTsk=";
  };

  cargoHash = "sha256-kuq1qT4OywO3miSoyMsTUo+o/3jcLjpzQ70lGHpvt+w=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  checkFlags = [
    # Tries to make network requests to other hosts
    "--skip=test_graph_single_day_filter_uses_local_timezone_boundaries"
    "--skip=test_pricing_command_json"
    "--skip=test_pricing_command_success"
    "--skip=test_pricing_command_with_provider"
    "--skip=test_auto_pinning_never_overwrites_a_settings_file_it_could_not_read"
    "--skip=test_auto_pinning_recovers_from_a_bucket_timezone_that_names_no_zone"
    "--skip=test_first_run_pins_the_host_timezone_without_changing_its_own_output"
    "--skip=test_submit_dry_run_preserves_local_date_ahead_of_utc"
    "--skip=test_submit_excluding_only_generic_gemini_usage_does_not_promise_submission"
    "--skip=test_unpinned_first_scan_still_buckets_by_the_host_timezone"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for tracking token usage from various agentic coding tools like Claude Code and OpenCode etc.";
    downloadPage = "https://github.com/junhoyeo/tokscale";
    homepage = "https://tokscale.ai";
    changelog = "https://github.com/junhoyeo/tokscale/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "tokscale";
  };
})
