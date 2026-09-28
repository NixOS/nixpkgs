{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "upmd";
  version = "0.2.7";

  dontConfigure = true;

  nativeCheckInputs = [
    # Needed for test:
    # runner::tests::unix::test_python_state_capture_roundtrip
    python3
  ];

  src = fetchFromGitHub {
    owner = "rezigned";
    repo = "upmd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NoxrbqhxVhV4HieqpzU5UpsLkisVKGc+yOSlxE7ywXk=";
  };

  cargoHash = "sha256-iv3eMQGMkzM7khOqjcudG+a/WzoJubqzum3m6ZWsgLs=";
  cargoLock.outputHashes = {
    "vt100-0.16.2" = "sha256-18opt/6FxwTx1CfWUEUm3QajujJvddBdvFDkRpopTtE=";
  };

  checkFlags = [
    # FIXME: Skipped because NixOS is not guaranteed to have /bin/bash,
    # which these tests rely on
    #
    # These tests pass in NixOS if /bin/bash is available
    "--skip=runner::tests::unix::test_bin_attr_without_config"
    "--skip=runner::tests::unix::test_bin_attr_takes_precedence_over_config"

    # Failing (seems to fail due to non-interactive shell during nix build)
    "--skip=apps::cli::app::tests::test_write_card_contains_code_and_separator"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v([\\d.]+)" ];
  };

  meta = {
    description = "Run any code blocks in markdown from the terminal";
    homepage = "http://upmd.dev/";
    mainProgram = "upmd";
    license = lib.licenses.mit;
  };
})
