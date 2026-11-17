{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usblog";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "inradii";
    repo = "usblog";
    tag = finalAttrs.version;
    hash = "sha256-86OiIfSy+KVD96OKEk2CrQCGWrrhqnIeUeSDP/I9OBA=";
  };

  cargoHash = "sha256-JhH+BrHqFtMWXvRtMau+YyAj0N7hZfUfc3eZa9DHM5s=";

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
