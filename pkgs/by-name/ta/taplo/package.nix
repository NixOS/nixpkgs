{
  stdenv,
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  withLsp ? true,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.10.0";

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
    hash = "sha256-iKc4Nu7AZE1LSuqXffi3XERbOqZMOkI3PV+6HaJzh4c=";
  };

  cargoHash = "sha256-tvijtB5fwOzQnnK/ClIvTbjCcMeqZpXcRdWWKZPIulM=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

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

  meta = with lib; {
    description = "TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "taplo";
  };
}
