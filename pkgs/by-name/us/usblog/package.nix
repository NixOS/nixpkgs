{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usblog";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "inradii";
    repo = "usblog";
    tag = finalAttrs.version;
    hash = "sha256-Ddkd6ViHrtmAwtUuhKBF3kNAARYS4935LqfkZhoeQP8=";
  };

  cargoHash = "sha256-OwGCNo+lWM+YObyNu04Q36fKHYmwCcsd7I3nlg0eDU8=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "USB event collection and diff tool for Linux";
    homepage = "https://github.com/inradii/usblog";
    changelog = "https://github.com/inradii/usblog/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "usblog";
    platforms = lib.platforms.linux;
  };
})
