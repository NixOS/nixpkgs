{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
let
  pname = "xremap";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "xremap";
    repo = "xremap";
    tag = "v${version}";
    hash = "sha256-Uzs1Pao/CV0pQd8AAk8FXD2v0O/wlFvmZkbHlqYCOEQ=";
  };

  cargoHash = "sha256-F1ao5YJv9UiU53Hg3UunE2gZc6iiB95zmCWjiHSkmHk=";

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
