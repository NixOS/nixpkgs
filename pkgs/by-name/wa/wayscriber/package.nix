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
  name = "wayscriber";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "devmobasa";
    repo = "wayscriber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BV87dBnKmPFCwKOBGEH/BS36NFkqXRecxVkBT+7HKDE=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pango
    libxkbcommon
  ];
  cargoHash = "sha256-a1Bb5Y37RBQJnGnqXNWV54BBAqeLlm5SxKHsODfNHww=";
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
