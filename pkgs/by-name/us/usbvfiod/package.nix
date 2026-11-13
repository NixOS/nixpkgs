{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbvfiod";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cyberus-technology";
    repo = "usbvfiod";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9/znBMDA0yLJVBnttgol9SCi6pzvbtEB9VmF5RGlYik=";
  };

  cargoHash = "sha256-lVHW70s8f3NYuKcyu8CQbGe+P7B3qETrv7mTxrp4o2Q=";

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
