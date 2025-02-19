{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:
let
  pname = "xremap";
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "xremap";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-U2TSx0O2T53lUiJNpSCUyvkG4Awa0+a4N6meFn09LbI=";
  };

  cargoHash = "sha256-8IVexszltzlBBShGkjZwyDKs02udrVpZEOwfzRzAraU=";

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

      useFetchCargoVendor = true;

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
