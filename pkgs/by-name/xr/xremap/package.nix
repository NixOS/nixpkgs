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
<<<<<<< HEAD
  version = "0.14.8";
=======
  version = "0.14.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-FPZ4iQA/vVZGzbO8i8lTK8i9A3zs9BLqMvTMeAVv9rQ=";
=======
    hash = "sha256-iqsLy6ZuU47s2eZ/Zo2A9svg1Q+UfpCCfSg1luRYdGg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ pkg-config ];

  buildNoDefaultFeatures = true;
  buildFeatures = variant.features;

<<<<<<< HEAD
  cargoHash = "sha256-FMd3z+49qvheFrlL81+diVJVKDjVy4am85IHR1IgA1U=";
=======
  cargoHash = "sha256-a7K+W4nPLSoGWBf1R7b3WZKrXn7hbOxaGnS1Vsg7Iak=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
