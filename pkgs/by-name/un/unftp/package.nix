{
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unftp";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "bolcom";
    repo = "unftp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/2IzVr3QQl7UV3WjG1bWntYdx2RXqKWrTkcwIBgnCsk=";
  };

  cargoHash = "sha256-2Mwp/bK0JFdCtCDkAAdpFpf8zxE0ueZNXTkZDaamGyg=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FTP(S) server with a couple of twists written in Rust";
    homepage = "https://unftp.rs/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aiyion ];
    mainProgram = "unftp";
  };
})
