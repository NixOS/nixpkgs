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

  # TODO investigate compilation failure for tests
  # there are about 100 tests failing (out of 1100) for version 0.22.0
  doCheck = false;

  checkFlags = [
    # tries to make a network access
    "--skip=sinks::loki::tests::healthcheck_grafana_cloud"

    # flaky on linux-aarch64
    "--skip=kubernetes::api_watcher::tests::test_stream_errors"

    # flaky on linux-x86_64
    "--skip=sources::socket::test::tcp_with_tls_intermediate_ca"
    "--skip=sources::host_metrics::cgroups::tests::generates_cgroups_metrics"
    "--skip=sources::aws_kinesis_firehose::tests::aws_kinesis_firehose_forwards_events"
    "--skip=sources::aws_kinesis_firehose::tests::aws_kinesis_firehose_forwards_events_gzip_request"
    "--skip=sources::aws_kinesis_firehose::tests::handles_acknowledgement_failure"
  ];

  # recent overhauls of DNS support in 0.9 mean that we try to resolve
  # vector.dev during the checkPhase, which obviously isn't going to work.
  # these tests in the DNS module are trivial though, so stubbing them out is
  # fine IMO.
  #
  # the geoip transform yields maxmindb.so which contains references to rustc.
  # neither figured out why the shared object is included in the output
  # (it doesn't seem to be a runtime dependencies of the geoip transform),
  # nor do I know why it depends on rustc.
  # However, in order for the closure size to stay at a reasonable level,
  # transforms-geoip is patched out of Cargo.toml for now - unless explicitly asked for.
  postPatch = ''
    substituteInPlace ./src/dns.rs \
      --replace-fail "#[tokio::test]" ""
  '';

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
