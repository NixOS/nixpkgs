{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
  rdkafka,
  oniguruma,
  zstd,
  rust-jemalloc-sys,
  rust-jemalloc-sys-unprefixed,
  libiconv,
  coreutils,
  tzdata,
  cmake,
  perl,
  git,
  nixosTests,
  nix-update-script,
  darwin,
  versionCheckHook,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vector";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "vectordotdev";
    repo = "vector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OFybPI2oppntYBEklJtdEhImZc/m4oaSSWylr2hHUjA=";
  };

  cargoHash = "sha256-Xuff8ZanFCtvitNYnOwCyd0UYjrhrP8UglJqbpScGVM=";

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    git
    rustPlatform.bindgenHook
    installShellFiles
  ]
  # Provides the mig command used by the build scripts
  ++ lib.optional stdenv.hostPlatform.isDarwin darwin.bootstrap_cmds;
  buildInputs = [
    oniguruma
    openssl
    protobuf
    rdkafka
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ rust-jemalloc-sys-unprefixed ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rust-jemalloc-sys
    libiconv
    coreutils
    zlib
  ];

  # Fix build with gcc 15
  # https://github.com/vectordotdev/vector/issues/22888
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  # Without this, we get SIGSEGV failure
  RUST_MIN_STACK = 33554432;

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  RUSTONIG_SYSTEM_LIBONIG = true;

  TZDIR = "${tzdata}/share/zoneinfo";

  # needed to dynamically link rdkafka
  CARGO_FEATURE_DYNAMIC_LINKING = 1;

  CARGO_PROFILE_RELEASE_LTO = "fat";
  CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";

  doCheck = true;
  checkType = "debug";

  checkFlags = [
    # Tries to make a network access
    "--skip=dns::tests::resolve_example"
    "--skip=sinks::loki::tests::healthcheck_grafana_cloud"

    # Requires secret server
    "--skip=secrets::exec::tests::test_exec_backend::case_1"
    "--skip=secrets::exec::tests::test_exec_backend::case_2"
    "--skip=secrets::exec::tests::test_exec_backend_missing_secrets"

    # Flakey
    "--skip=sources::host_metrics::cgroups::tests::generates_cgroups_metrics"
    "--skip=sources::host_metrics::cpu::tests::generates_cpu_metrics"
    "--skip=sources::internal_logs::tests::repeated_logs_are_not_rate_limited"

    # Requires access to journalctl
    "--skip=sources::journald::tests::emits_cursor"
    "--skip=sources::journald::tests::excludes_matches"
    "--skip=sources::journald::tests::excludes_units"
    "--skip=sources::journald::tests::handles_acknowledgements"
    "--skip=sources::journald::tests::handles_checkpoint"
    "--skip=sources::journald::tests::handles_missing_timestamp"
    "--skip=sources::journald::tests::includes_kernel"
    "--skip=sources::journald::tests::includes_matches"
    "--skip=sources::journald::tests::includes_units"
    "--skip=sources::journald::tests::parses_array_fields"
    "--skip=sources::journald::tests::parses_array_messages"
    "--skip=sources::journald::tests::parses_string_sequences"
    "--skip=sources::journald::tests::reads_journal"

    # No multicast access avaiable in sandbox
    "--skip=sources::socket::test::multicast_and_unicast_udp_message"
    "--skip=sources::socket::test::multicast_udp_message"
    "--skip=sources::socket::test::multiple_multicast_addresses_udp_message"
    "--skip=sources::syslog::test::test_udp_syslog"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd vector --$shell <($out/bin/vector completion $shell)
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests) vector;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "High-performance observability data pipeline";
    homepage = "https://github.com/vectordotdev/vector";
    changelog = "https://github.com/vectordotdev/vector/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      adamcstephens
      thoughtpolice
      happysalada
    ];
    platforms = with lib.platforms; all;
    mainProgram = "vector";
  };
})
