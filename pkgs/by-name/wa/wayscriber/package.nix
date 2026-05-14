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
  version = "0.9.17";

  src = fetchFromGitHub {
    owner = "devmobasa";
    repo = "wayscriber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ylvZ+U8et9McvZrHsJFLoWWAtruQnKMk/5lg4uCw/rg=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libxkbcommon
  ];
  cargoHash = "sha256-/q4ux2MXDfrqbUfO1M2lykpDl03MTnVS4ottxSgDFEQ=";
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
