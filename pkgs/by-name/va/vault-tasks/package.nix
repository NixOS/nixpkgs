{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  buildPackages,
  installShellFiles,
  nix-update-script,
}:
let
  version = "0.13.0";
in
rustPlatform.buildRustPackage {
  pname = "vault-tasks";
  inherit version;
  src = fetchFromGitHub {
    owner = "louis-thevenet";
    repo = "vault-tasks";
    rev = "v${version}";
    hash = "sha256-XWeY2l82n51O4/LKPOJZOXf7PCRPOUshFg832iDvmuA=";
  };

  cargoHash = "sha256-znc2oKpovsXyrUhKvBVMorv7yWM39xNgaNDiq/5I6Dg=";

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
        --bash <(${vault-tasks}/bin/vault-tasks generate-completions bash) \
        --fish <(${vault-tasks}/bin/vault-tasks generate-completions fish) \
        --zsh <(${vault-tasks}/bin/vault-tasks generate-completions zsh)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI Markdown Task Manager";
    longDescription = ''
      vault-tasks is a TUI Markdown task manager.
      It will parse any Markdown file or vault and display the tasks it contains.
    '';
    homepage = "https://github.com/louis-thevenet/vault-tasks";
    license = lib.licenses.mit;
    mainProgram = "vault-tasks";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
