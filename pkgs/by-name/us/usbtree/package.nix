{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "usbtree";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gnomeria";
    repo = "usbtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-52Ppiv2bYLJR4/h0gyxfBtRnyCQkfNBmCNyr5hWe3uY=";
  };

  cargoHash = "sha256-ux1S/0pu7at3UyYiWLpCsrxtd/Hoqf8l9Egp4HIHogY=";

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
