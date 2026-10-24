{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "workmux";
  version = "0.1.184";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "raine";
    repo = "workmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zrR1CNkAl9KiQp6B0cY/5kIh21zRDVVX67hSz3KtJCM=";
  };

  cargoHash = "sha256-2Q8ronyiU1ATwxMnWvr/rp7M09lphzHOUpvTyToVi/g=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [
    # Sandbox RPC and network proxy tests bind Unix/TCP sockets, which the
    # Nix build sandbox on Darwin doesn't permit.
    "--skip=sandbox::network_proxy::tests"
    "--skip=sandbox::rpc::tests"
  ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd workmux \
        --bash <($out/bin/workmux completions bash) \
        --fish <($out/bin/workmux completions fish) \
        --zsh <($out/bin/workmux completions zsh)
    ''
    + ''
      mkdir -p $out/share/workmux
      cp -r skills $out/share/workmux/skills
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # workmux writes a log file under $HOME on startup; pass HOME (set by
  # writableTmpDirAsHomeHook) through versionCheckHook's env-stripping subshell.
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git worktrees + tmux windows for zero-friction parallel dev";
    homepage = "https://github.com/raine/workmux";
    changelog = "https://github.com/raine/workmux/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "workmux";
    maintainers = with lib.maintainers; [ sei40kr ];
    platforms = lib.platforms.unix;
  };
})
