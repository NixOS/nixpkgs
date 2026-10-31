{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo-tauri,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  wrapGAppsHook4,
  webkitgtk_4_1,
  pkg-config,
  openssl,
  cacert,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tabularis";
  version = "0.29.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TabularisDB";
    repo = "tabularis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u/sNbmUXHE76aOh/MgujuWXA0TOgnAcLgxcHRo3EJTI=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-fJnlkmjSAlK5G7+y8LnEyW8IlRDP9kJqLC9wTEtzUq4=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-/E40mIMYLSQhoE/uxO6I+X3qdTdiyNOGKk1vI3FhJtA=";
  };

  postPatch = ''
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pnpmConfigHook
    pnpm

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  nativeCheckInputs = [ cacert ];

  # Fails in sandbox
  checkFlags = map (x: "--skip=${x}") [
    "plugins::compat::tests::json_suffix_url_takes_legacy_path"
    "plugins::connection_metadata::tests::concurrent_discovery_is_shared_and_reconnect_refreshes"
    "plugins::connection_metadata::tests::only_remote_method_not_found_falls_back"
    "plugins::connection_metadata::tests::rpc_snapshots_isolate_types_dialect_and_sql_fallbacks"
    "plugins::connection_metadata::tests::static_plugin_receives_no_discovery_rpc"
    "plugins::driver::startup_tests::registering_an_unresponsive_plugin_does_not_wait_for_handshake"
    "pool_manager_tests::postgres_tls_connector_tests::test_tls_connector_accepts_every_produced_ssl_mode"
    "pool_manager_tests::postgres_tls_connector_tests::test_tls_connector_verify_full"
    "ssm_tunnel::tests::extend_path_tests::an_empty_inherited_path_still_gains_the_well_known_directories"
    "ssm_tunnel::tests::extend_path_tests::appends_well_known_directories_after_the_inherited_ones"
    "theme_packages::tests::author_journeys::author_generated_archives_use_read_only_discovery_and_exact_tracked_registry_updates"
    "theme_packages::tests::transport::cancellation_during_redirected_download_has_no_commit_or_profile_write"
    "theme_packages::tests::transport::integrity_and_download_limits_leave_the_previous_installation_unchanged"
    "theme_packages::tests::transport::latest_and_explicit_updates_follow_one_tracked_redirect_and_preserve_preferences"
    "theme_packages::tests::transport_edges::latest_archive_version_drift_preserves_the_previous_package"
  ];

  env.OPENSSL_NO_VENDOR = 1;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, developer-focused database management tool, built with Tauri and React";
    homepage = "http://tabularis.dev";
    changelog = "https://github.com/TabularisDB/tabularis/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "tabularis";
  };
})
