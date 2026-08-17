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
  version = "0.61.0";

  src = fetchFromGitHub {
    owner = "max-sixty";
    repo = "worktrunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jyj9e1E9wPxcMuWl3/nDrPTh68yNRuxMOEFmvjE3dRk=";
  };

  cargoHash = "sha256-iKOLHyY28CXPAdPmjVocoubOVKPoBTqA/NJ522cC8+o=";

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
      --nushell <($out/bin/wt config shell completions nu) \
      --zsh <($out/bin/wt config shell completions zsh)
  '';

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [
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
    maintainers = with lib.maintainers; [
      siriobalmelli
      DuskyElf
    ];
  };
})
