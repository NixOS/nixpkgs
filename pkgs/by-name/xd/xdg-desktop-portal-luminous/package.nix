{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  rustc,
  cargo,
  rustPlatform,
  xdg-desktop-portal,
  slurp,
  cairo,
  pango,
  libxkbcommon,
  glib,
  pipewire,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-luminous";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "xdg-desktop-portal-luminous";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qdR4wuRqq+PgJPbAtG8xvgWC7NwAeWGJiBXTWWdfyCY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-MIbhNlB2Mv5gOHlVoB93aQczbq9qo+WP/Rz6pWEoxWU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    rustc
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    xdg-desktop-portal
    slurp
    cairo
    pango
    glib
    pipewire
    libxkbcommon
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "xdg-desktop-portal backend for wlroots based compositors, providing screenshot and screencast";
    homepage = "https://github.com/waycrate/xdg-desktop-portal-luminous";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Rishik-Y ];
  };
})
