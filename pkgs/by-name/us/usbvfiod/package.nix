{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbvfiod";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cyberus-technology";
    repo = "usbvfiod";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SG5S0wRue/G31XuR2D8xFrbAIhWG3rl+aNjEnhZ7dmI=";
  };

  cargoHash = "sha256-nTNUC7Tiib2wWYC1g7S1W7wgIkqZLTN8aKUKjpgZlqo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/cyberus-technology/usbvfiod";
    description = "A tool for USB device pass-through using the vfio-user protocol.";
    changelog = "https://github.com/cyberus-technology/usbvfiod/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "usbvfiod";
    maintainers = with lib.maintainers; [
      lbeierlieb
    ];
    platforms = [
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
})
