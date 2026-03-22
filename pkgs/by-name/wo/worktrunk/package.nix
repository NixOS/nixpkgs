{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  gitMinimal,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worktrunk";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "max-sixty";
    repo = "worktrunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D/S2KBa3fmgUO8x1HubOIti/oXGEXDkto03+PFrtH/Q=";
  };

  cargoHash = "sha256-UDpYUgrhw/raDnVVW3rT35/Iae5eVcnCWMX59of1htg=";

  cargoBuildFlags = [ "--package=worktrunk" ];

  # vergen-gitcl calls `git describe` at build time; VERGEN_IDEMPOTENT makes it
  # fall back gracefully when no git history is available (Nix sandbox).
  env.VERGEN_IDEMPOTENT = "1";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # wt reads config from $HOME; provide a throwaway dir so it doesn't fail.
    export HOME="$(mktemp -d)"

    installShellCompletion --cmd wt \
      --bash <($out/bin/wt config shell completions bash) \
      --fish <($out/bin/wt config shell completions fish) \
      --zsh  <($out/bin/wt config shell completions zsh)
  '';

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [
    # Expects to run inside a git repository
    "--skip=git::recover::tests::test_current_or_recover_returns_repo_when_cwd_exists"
    # Insta snapshot mismatch across git versions
    "--skip=git::recover::tests::test_hint_for_repo_suggests_switch"
    # Expects `which` on PATH
    "--skip=output::commit_generation::tests::test_command_exists_known_command"
    # Integration tests use insta snapshots with environment-specific paths
    "--skip=integration_tests::"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git worktree manager for parallel AI agent workflows";
    longDescription = ''
      worktrunk wraps git worktree with a simpler interface and integrates with
      AI coding tools like Claude Code, Cursor, and Aider.
    '';
    homepage = "https://worktrunk.dev/";
    changelog = "https://github.com/max-sixty/worktrunk/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wt";
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
})
