{
  stdenv,
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  withLsp ? true,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taplo";
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "taplo-cli";
    hash = "sha256-iKc4Nu7AZE1LSuqXffi3XERbOqZMOkI3PV+6HaJzh4c=";
  };

  cargoHash = "sha256-tvijtB5fwOzQnnK/ClIvTbjCcMeqZpXcRdWWKZPIulM=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  buildFeatures = lib.optional withLsp "lsp";

  postInstall =
    lib.optionalString
      (
        stdenv.buildPlatform.canExecute stdenv.hostPlatform
        &&
          # Creation of the completions fails on Darwin platforms.
          !stdenv.hostPlatform.isDarwin
      )
      ''
        installShellCompletion --cmd taplo \
          --bash <($out/bin/taplo completions bash) \
          --fish <($out/bin/taplo completions fish) \
          --zsh <($out/bin/taplo completions zsh)
      '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "taplo";
  };
})
