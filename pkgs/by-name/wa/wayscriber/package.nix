{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  pango,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayscriber";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "devmobasa";
    repo = "wayscriber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5CHEMed3QZ8xixMm/wDdR+kt7TnG8jwuy4wWKyTP3bg=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libxkbcommon
  ];
  cargoHash = "sha256-AXVZ8Lk/Ie58SVrYRITEdrGEEe5gA5RD6y0HlLZUlnk=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ZoomIt-like screen annotation tool for Wayland compositors, written in Rust";
    homepage = "https://wayscriber.com";
    changelog = "https://github.com/devmobasa/wayscriber/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      leiserfg
    ];
    mainProgram = "wayscriber";
    platforms = lib.platforms.linux;
  };
})
