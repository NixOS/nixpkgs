{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (final: {
  pname = "tirith";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "sheeki03";
    repo = "tirith";
    tag = "v${final.version}";
    hash = "sha256-WyLcLKQ75UVaE6WtT0CaxfDS4qY/ShO9roMxQJPp5qE=";
  };

  cargoHash = "sha256-MYYAltyAFFt1BSkOwWpMEKw5rzQfduzDG7JcBEzKbOg=";

  cargoBuildFlags = [
    "-p"
    "tirith"
  ];

  # crates/tirith/tests/* needs git, a PTY, network, or a writable home
  cargoTestFlags = [
    "--bins"
  ];

  postPatch = ''
    # The bash_preexec_enforce tests require a shell with job control
    rm crates/tirith/tests/bash_preexec_enforce.rs
  '';

  checkFlags = [
    # requires a fully functional shell environment, generating init scripts needs a patch under nix to work at build time
    "--skip=bash_capability_cache_steers_default_mode"
    "--skip=bash_enter_degradation_is_visible_not_silent"
    "--skip=cli::clipboard::tests::copy_path_does_not_consult_sidecar"
    "--skip=clipboard_watch_exits_when_stdout_pipe_closed"
    "--skip=init_bash_output"
    "--skip=init_prompt_status_emits_marker_wrapped_snippet_zsh"
    "--skip=init_prompt_status_is_idempotent_when_run_twice"
    "--skip=init_prompt_status_supports_bash_and_fish_and_powershell"
    "--skip=init_without_prompt_status_does_not_emit_snippet"
    "--skip=init_zsh_output"
    # fails with: no such file or directory
    "--skip=cli::checkpoint::tests::restore_checkpoint_nonzero_on_partial_failure"
    "--skip=cli::checkpoint::tests::run_command_preserves_multiple_argv_boundaries"
    # nix sandbox: /bin/sh is not root-owned, no POSIX ACLs, HOME=/homeless-shelter, no ptrace
    "--skip=cli::capsule::"
    "--skip=cli::capsule_child::"
    "--skip=cli::install::tests::"
    "--skip=cli::selfupdate::tests::extract_tirith_binary"
    "--skip=cli::selfupdate::tests::hermes_install_proof"
    "--skip=cli::selfupdate::tests::lost_hermes_reproof"
    "--skip=cli::setup::fs_helpers::tests::cli_runner"
    "--skip=cli::setup::run_impl::tests::generated_tirith_bin"
    "--skip=cli::setup::tools::tests::"
    "--skip=cli::task_receipt_keys::"
    "--skip=cli::fetch::tests::human_renderer_neutralizes_untrusted_terminal_controls"
    "--skip=cli::gateway::tests::exact_launch_"
    # tirith-threatdb-compile: needs a git checkout
    "--skip=git_source_revision_and_tracked_cleanliness_are_enforced"
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tirith \
      --bash <("$out/bin/tirith" completions bash) \
      --zsh <("$out/bin/tirith" completions zsh) \
      --fish <("$out/bin/tirith" completions fish)
  '';

  meta = {
    description = "Shell security tool that guards against homograph URL attacks, pipe-to-shell exploits, and other command-line threats before they execute";
    homepage = "https://github.com/sheeki03/tirith";
    changelog = "https://github.com/sheeki03/tirith/blob/${final.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ toasteruwu ];
    platforms = lib.platforms.unix;
    mainProgram = "tirith";
  };
})
