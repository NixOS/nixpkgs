{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "tamasfe";
    repo = "taplo";
    tag = "release-taplo-cli-${finalAttrs.version}";
    hash = "sha256-FW8OQ5TRUuQK8M2NDmp4c6p22jsHodxKqzOMrcdiqXU=";
  };

  cargoPatches = [
    # Update reqwest to fix darwin sandboxing issues
    # See also: https://github.com/tamasfe/taplo/pull/669
    ./update-reqwest.patch
  ];

  cargoHash = "sha256-FMpGo+kRcNgDj4qwYvdQKGwGazUKKMIVq0HCYMrTql0=";

  buildAndTestSubdir = "crates/taplo-cli";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  buildFeatures = lib.optional withLsp "lsp";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    maintainers = with lib.maintainers; [
      defelo
      yzx9
    ];
    mainProgram = "taplo";
  };
})
