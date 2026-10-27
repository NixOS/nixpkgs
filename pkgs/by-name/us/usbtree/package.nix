{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbtree";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gnomeria";
    repo = "usbtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-780SdrC2vaLQKJElabevYifBSv1WUOwjqYfbj7Fsm3E=";
  };

  cargoHash = "sha256-6uP2YuPeZVZa+AKOyki+hgvE28+yWkPvpt+QifFOxgo=";

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
