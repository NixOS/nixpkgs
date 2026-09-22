{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbvfiod";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cyberus-technology";
    repo = "usbvfiod";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gYKWmUaB7c5netQjR7qHKuBq82X3J+o4gQCsB/3cq50=";
  };

  cargoHash = "sha256-B4iyADjXjX7VdGaTIdCKUalwJt6vMVnqqUCyLsu5wUI=";

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
      snu
    ];
    platforms = [
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
})
