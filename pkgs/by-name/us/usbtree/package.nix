{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbtree";
  version = "0.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gnomeria";
    repo = "usbtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jpOFKNauivxE+gs7geqgyoCYUS1/4MYkzs20BxeJAQQ=";
  };

  cargoHash = "sha256-eo2+4PnXX9hi+BJVepXpme2INZDhRxDY5EV3wRIruGY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Live USB device tree in your terminal. Rust TUI, no root, no libusb. Full activity metrics on Linux; device tree on macOS/Windows";
    homepage = "https://github.com/gnomeria/usbtree";
    changelog = "https://github.com/gnomeria/usbtree/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.djacu
    ];
    mainProgram = "usbtree";
  };
})
