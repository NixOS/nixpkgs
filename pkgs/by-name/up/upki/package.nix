{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "upki";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "upki";
    tag = "upki-${finalAttrs.version}";
    hash = "sha256-F+35W3lCoZ4Oq5tq2zbtBeU7lXVx9/tA3OY2UvkqsWU=";
  };

  cargoHash = "sha256-RXWeZT9c1lSVrz4J0XdxOmLmYtzwJgIQlXrvwGvkB78=";

  buildAndTestSubdir = "upki";

  # upki uses inta_cmd to run some integration tests
  # It needs some help to find the binary to run
  preCheck = ''
    export CARGO_BIN_EXE_upki="$(pwd)"/target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/upki
  '';

  checkFlags = [
    # Skip integration tests having some expectations on the current state of the system
    "--skip=fetch_of_empty_manifest"
    "--skip=full_fetch_and_incremental_update"
    "--skip=full_fetch_and_incremental_update"
    "--skip=full_fetch"
    "--skip=typical_incremental_fetch_dry_run"
    "--skip=typical_incremental_fetch"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Platform-independent browser-grade certificate infrastructure";
    homepage = "https://github.com/rustls/upki/tree/main/upki";
    changelog = "https://github.com/rustls/upki/releases/tag/upki-${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.lesuisse ];
    mainProgram = "upki";
  };
})
