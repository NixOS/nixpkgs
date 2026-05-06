{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  pkg-config,
  pam,
  wayland,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "veila";
  version = "0.1.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "naurissteins";
    repo = "Veila";
    tag = finalAttrs.version;
    hash = "sha256-zpOhERNpnEqzdKm32hAWwxthWteV81XBHxNOdGpsh+A=";
  };

  cargoHash = "sha256-1h9DkF6PtkaBuyspPgt2jGHZl+y3/J63sJmzq2Pk94c=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    pam
    wayland
    libxkbcommon
  ];

  cargoBuildFlags = [ "--workspace" ];

  postInstall = ''
    pushd assets
    for assetDir in bg fonts icons systemd themes; do
      find "$assetDir" -type d -exec install -d "$out/share/veila/{}" ';'
      find "$assetDir" -type f -exec install -Dm644 "{}" "$out/share/veila/{}" ';'
    done
    popd

    wrapProgram "$out/bin/veila" \
      --set VEILA_ASSET_DIR "$out/share/veila"

    wrapProgram "$out/bin/veila-curtain" \
      --set VEILA_ASSET_DIR "$out/share/veila"

    wrapProgram "$out/bin/veilad" \
      --set VEILA_ASSET_DIR "$out/share/veila" \
      --set VEILA_CURTAIN_BIN "$out/bin/veila-curtain"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screen locker for Wayland compositors";
    homepage = "https://naurissteins.com/veila";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ naurissteins ];
    platforms = lib.platforms.linux;
    mainProgram = "veila";
  };
})
