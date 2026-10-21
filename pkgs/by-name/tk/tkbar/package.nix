{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
  glib,
  gsettings-desktop-schemas,
  pipewire,

  # Build-time variants: pkgs.tkbar.override { ... }
  color ? "black",
  wm ? "niri",
  components ? [
    "battery"
    "brightness"
    "clock"
    "volume"
    "wifi"
  ],
  withConfig ? true,
  withCli ? false,
}:

assert lib.assertMsg (builtins.elem color [
  "black"
  "blue"
  "cyan"
  "green"
  "orange"
  "pink"
  "purple"
  "red"
  "white"
  "yellow"
]) "tkbar: unknown color '${color}'";
assert lib.assertMsg (
  wm == null
  || builtins.elem wm [
    "niri"
    "hyprland"
    "sway"
  ]
) "tkbar: unknown WM backend '${wm}'";
assert lib.assertMsg (lib.all (
  c:
  builtins.elem c [
    "battery"
    "brightness"
    "clock"
    "volume"
    "wifi"
  ]
) components) "tkbar: unknown component in '${lib.concatStringsSep ", " components}'";

let
  withVolume = builtins.elem "volume" components;
  features = [
    color
  ]
  ++ lib.optional (wm != null) wm
  ++ lib.optional withConfig "config"
  ++ lib.optional withCli "cli"
  ++ components;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tkbar";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tkr-sh";
    repo = "tkbar";
    tag = finalAttrs.version;
    hash = "sha256-VEca+B4bBWkh9DPPLShoVsnoPhboTUobmmtoGcWdgxU=";
  };

  cargoHash = "sha256-Odtdur5I8jSkd1YRJP01zwjubhQqqQNgmjUNd6se680=";

  buildNoDefaultFeatures = true;
  buildFeatures = features;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ]
  ++ lib.optionals withVolume [ rustPlatform.bindgenHook ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    glib
    gsettings-desktop-schemas
  ]
  ++ lib.optionals withVolume [ pipewire ];

  preFixup = ''
    gappsWrapperArgs+=(
      "--set" "GDK_PIXBUF_MODULE_FILE" "/dev/null"
      "--set" "GTK_A11Y" "none"
      "--set" "GSK_RENDERER" "cairo"
      "--set" "GDK_DISABLE" "gl,vulkan,dmabuf"
      "--set" "GDK_BACKEND" "wayland"
      "--set" "GDK_DEBUG" "no-portals"
    )
  '';

  meta = {
    description = "Minimalist, hardened status bar for Wayland";
    homepage = "https://github.com/tkr-sh/tkbar";
    license = lib.licenses.gpl3Plus;
    mainProgram = "tkbar";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tk ];
  };
})
