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
  };

  variant = variants.${withVariant} or null;
in
assert (
  lib.assertMsg (variant != null)
    "Unknown variant ${withVariant}: expected one of ${lib.concatStringsSep ", " (lib.attrNames variants)}"
);
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xremap${variant.suffix or ""}";
  version = "0.14.18";

  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bn5Qq3pcrxTKUBfMkoK1xtLl4c4tHafe74REMQS+cz8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildNoDefaultFeatures = true;
  buildFeatures = variant.features;

  cargoHash = "sha256-MJ41A8hUurevmy9MX1qB32T8J4KaZO/gDA96CmTuIBU=";

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
