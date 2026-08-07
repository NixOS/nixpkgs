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
  version = "0.71.0";

  src = fetchFromGitHub {
    owner = "max-sixty";
    repo = "worktrunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TBna2iFzrVyfa4D/rDysQdZPS5yHEv/mTY8ixc4GilE=";
  };

  cargoHash = "sha256-UdSWEP9m/b9xtEtyX5JWvF4LU2uJdbk4juYrKwrx4gA=";

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

    # -L dereferences symlinks (e.g. skills/worktrunk/reference/README.md → repo
    # root), so no dangling symlinks end up in $out.
    cp -RL ${finalAttrs.src}/skills $out/
  '';

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [
    # Expects `which` on PATH
    "--skip=output::commit_generation::tests::test_command_exists_known_command"
    # Integration tests use insta snapshots with environment-specific paths
    "--skip=integration_tests::"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests probe the live process table — on macOS that means libproc
    # (`proc_listallpids` / `proc_pidinfo`). Inside the Nix darwin sandbox,
    # those calls are denied. The build process can't even read its own pid
    # from the table, so two tests panic:
    "--skip=shell::utils::tests::test_process_name_and_ppid_self"
    "--skip=shell::utils::tests::test_probe_reports_invoked_name_for_sh"
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
      yzx9
    ];
  };
})
