{
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "unftp";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "bolcom";
    repo = "unftp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z9Cse4/QO7uH46foL7lagtffZGhfZ24rS/yP3A9s9zU=";
  };

  cargoHash = "sha256-fR03iwfd5QZ3iU4jxYcQbVcgR+s+dUIRIIgHDt+n8EA=";

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
