{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
let
  pname = "xremap";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    tag = "v${version}";
    hash = "sha256-5BHet5kKpmJFpjga7QZoLPydtzs5iPX5glxP4YvsYx0=";
  };

  cargoHash = "sha256-NZNLO+wmzEdIZPp5Zu81m/ux8Au+8EMq31QpuZN9l5w=";

  buildXremap =
    {
      suffix ? "",
      features ? [ ],
      descriptionSuffix ? "",
    }:
    assert descriptionSuffix != "" && features != [ ];
    rustPlatform.buildRustPackage {
      pname = "${pname}${suffix}";
      inherit version src cargoHash;

      nativeBuildInputs = [ pkg-config ];

      buildNoDefaultFeatures = true;
      buildFeatures = features;

      meta = {
        description =
          "Key remapper for X11 and Wayland"
          + lib.optionalString (descriptionSuffix != "") " (${descriptionSuffix} support)";
        homepage = "https://github.com/xremap/xremap";
        changelog = "https://github.com/xremap/xremap/blob/${src.tag}/CHANGELOG.md";
        license = lib.licenses.mit;
        mainProgram = "xremap";
        maintainers = [ lib.maintainers.hakan-demirli ];
        platforms = lib.platforms.linux;
      };
    };

  variants = {
    x11 = buildXremap {
      features = [ "x11" ];
      descriptionSuffix = "X11";
    };
    gnome = buildXremap {
      suffix = "-gnome";
      features = [ "gnome" ];
      descriptionSuffix = "Gnome";
    };
    kde = buildXremap {
      suffix = "-kde";
      features = [ "kde" ];
      descriptionSuffix = "KDE";
    };
    wlroots = buildXremap {
      suffix = "-wlroots";
      features = [ "wlroots" ];
      descriptionSuffix = "wlroots";
    };
    hyprland = buildXremap {
      suffix = "-hyprland";
      features = [ "hypr" ];
      descriptionSuffix = "Hyprland";
    };
  };

in
variants.wlroots.overrideAttrs (finalAttrs: {
  passthru = {
    gnome = variants.gnome;
    kde = variants.kde;
    wlroots = variants.wlroots;
    hyprland = variants.hyprland;
    x11 = variants.x11;
  };
})
