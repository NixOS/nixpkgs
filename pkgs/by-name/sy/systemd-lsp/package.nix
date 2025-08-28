{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    rev = "43e0a26b12653b97939612ce8f4e2f3bae562ea1";
    hash = "sha256-l2/8khzXZjyga4nEdl4pcl3AOscCBxZHH3tW3Cv+RUk=";
  };

  cargoHash = "sha256-bYksgHTXomeEJuSk800+/PYXzMvrixSjfPnoqxStWAA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
  };
})
