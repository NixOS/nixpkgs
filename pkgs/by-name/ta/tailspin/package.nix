{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  procps,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tailspin";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    tag = finalAttrs.version;
    hash = "sha256-RI604v8ImQSgvNUGsnCLe6FuzEMJwE0tNVuFLmJLwvM=";
  };

  cargoHash = "sha256-kcd6rBoonoCKuybVIVtZqt+njHFhVDTjTyF2UURuOSI=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ procps ];
  checkFlags = lib.optionals (!(stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isCygwin)) [
    # Requires pgrep, which is not provided by procps on non-Linux systems
    "--skip=failing_pager_spawn_kills_the_exec_child"
    "--skip=pager_killed_by_ctrl_c_is_a_quiet_quit"
    "--skip=quitting_the_pager_kills_the_exec_child"
    "--skip=stream_error_while_paging_kills_the_pager"
  ];

  postInstall = ''
    installShellCompletion completions/tspin.{bash,fish,zsh}
    installManPage man/tspin.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/tspin";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "tspin";
  };
})
