{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  buildPackages,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vault-tasks";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = "vault-tasks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vNAqytsApQSxKbPFVeKdevtGiplOhFHO83eXJ5YheFk=";
  };

  cargoHash = "sha256-srlEkNQ84gNI9qPZmPdZwcoJC9Knf0jEmldLrxQIEWA=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    install -Dm444 desktop/vault-tasks.desktop -t $out/share/applications
  ''
  + (
    let
      vault-tasks =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.vault-tasks;
    in
    ''
      # vault-tasks tries to load a config file from ~/.config/ before generating completions
      export HOME="$(mktemp -d)"

      installShellCompletion --cmd vault-tasks \
        --bash <(${vault-tasks}/bin/vault-tasks-tui generate-completions bash) \
        --fish <(${vault-tasks}/bin/vault-tasks-tui generate-completions fish) \
        --zsh <(${vault-tasks}/bin/vault-tasks-tui generate-completions zsh)
    ''
  );

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI Markdown Task Manager";
    longDescription = ''
      vault-tasks is a TUI Markdown task manager.
      It will parse any Markdown file or vault and display the tasks it contains.
    '';
    homepage = "https://github.com/louis-thevenet/vault-tasks";
    license = lib.licenses.mit;
    mainProgram = "vault-tasks-tui";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
})
