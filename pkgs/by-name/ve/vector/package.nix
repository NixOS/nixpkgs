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
  cyrus_sasl,
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
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "vectordotdev";
    repo = "vector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cV1BXvdMiHvm7igf0qSvECPtPvOzTQNadOGMkpcHYS8=";
  };

  cargoHash = "sha256-uF2HQAj6NHnL3ZqLUgl1u9Xjc8/scz78CDgWgVMvp2w=";

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
    cyrus_sasl
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

  env = {
    # Fix build with gcc 15
    # https://github.com/vectordotdev/vector/issues/22888
    NIX_CFLAGS_COMPILE = "-std=gnu17";

    # Without this, we get SIGSEGV failure
    RUST_MIN_STACK = 33554432;

    # needed for internal protobuf c wrapper library
    PROTOC = "${protobuf}/bin/protoc";
    RUSTONIG_SYSTEM_LIBONIG = true;

    # upstream forces openssl/vendored
    OPENSSL_NO_VENDOR = true;

    TZDIR = "${tzdata}/share/zoneinfo";

    # needed to dynamically link rdkafka
    CARGO_FEATURE_DYNAMIC_LINKING = 1;

    CARGO_PROFILE_RELEASE_LTO = "fat";
    CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "1";
  };

  # upstream does not keep up to date with rust. let's not fail on every warning
  postPatch = ''
    sed -i 's/#!\[deny(warnings)]/#!\[warn(warnings)]/' lib/*/src/lib.rs src/lib.rs src/main.rs vdev/src/main.rs
  '';

  # tests have proven too flaky and required too many exclusions
  doCheck = false;

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
    tests = nixosTests.vector;
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
