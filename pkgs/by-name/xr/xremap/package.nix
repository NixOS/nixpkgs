{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xremap,

  withVariant ? "wlroots",
}:
let
  variants = {
    x11 = {
      features = [ "x11" ];
      descriptionSuffix = "X11";
    };
    gnome = {
      suffix = "-gnome";
      features = [ "gnome" ];
      descriptionSuffix = "Gnome";
    };
    kde = {
      suffix = "-kde";
      features = [ "kde" ];
      descriptionSuffix = "KDE";
    };
    wlroots = {
      suffix = "-wlroots";
      features = [ "wlroots" ];
      descriptionSuffix = "wlroots";
    };
    hyprland = {
      suffix = "-hyprland";
      features = [ "hypr" ];
      descriptionSuffix = "Hyprland";
    };
    niri = {
      suffix = "-niri";
      features = [ "niri" ];
      descriptionSuffix = "Niri";
    };
    cosmic = {
      suffix = "-cosmic";
      features = [ "cosmic" ];
      descriptionSuffix = "Cosmic";
    };
    socket = {
      suffix = "";
      features = [ "socket" ];
      descriptionSuffix = "Socket client";
    };
  };

  variant = variants.${withVariant} or null;
in
assert (
  lib.assertMsg (variant != null)
    "Unknown variant ${withVariant}: expected one of ${lib.concatStringsSep ", " (lib.attrNames variants)}"
);
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xremap${variant.suffix or ""}";
  version = "0.14.19";

  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t/eSUFYTZ41uJJLjmMOWiV9ffYJjDVw+fy0P3XnvJ40=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildNoDefaultFeatures = true;
  buildFeatures = variant.features;

  cargoHash = "sha256-Ypujuqz8TNLNfNB1NizjZoOK2VL+a4MY7c/aGIcCjns=";

  passthru = lib.mapAttrs (name: lib.const (xremap.override { withVariant = name; })) variants;

  meta = {
    description = "Key remapper for X11 and Wayland (${variant.descriptionSuffix} support)";
    homepage = "https://github.com/xremap/xremap";
    changelog = "https://github.com/xremap/xremap/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "xremap";
    maintainers = [ lib.maintainers.hakan-demirli ];
    platforms = lib.platforms.linux;
  };
})
