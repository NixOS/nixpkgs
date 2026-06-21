{
  lib,
  glib,
  fetchFromGitHub,
  nix-update-script,
  pango,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "waysip";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "waysip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QLXiQoL+S4T6RYe5vu2fSERUk/ZjEozXLg3rA3Dpn+Q=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    pango
  ];
  cargoHash = "sha256-qhPXDeNnyYoH8h5CQvCZ/yHU+xzs+ZNEBVCRdIdguCM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland native area selector for compositors implementing zwlr_layer_shell";
    homepage = "https://github.com/waycrate/waysip";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      id3v1669
    ];
    platforms = lib.platforms.linux;
    mainProgram = "waysip";
  };
})
