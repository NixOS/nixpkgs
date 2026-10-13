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
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "devmobasa";
    repo = "wayscriber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g9LFceW05miR6PyHb6p3RvB1mnhAI/V/AeAYtmGplSA=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libxkbcommon
  ];
  cargoHash = "sha256-QNzUjY3k8OLsOLzMuEKFy1xcAHVsUOQMipL0c3T7tsY=";
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
