{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome-shell,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  unstableGitUpdater,
  colorVariants ? [ ],
  sizeVariants ? [ ],
  themeVariants ? [ ],
  tweakVariants ? [ ],
  iconVariants ? [ ],
}:

let
  pname = "tokyonight-gtk-theme";
  colorVariantList = [
    "dark"
    "light"
  ];
  sizeVariantList = [
    "compact"
    "standard"
  ];
  themeVariantList = [
    "default"
    "green"
    "grey"
    "orange"
    "pink"
    "purple"
    "red"
    "teal"
    "yellow"
    "all"
  ];
  tweakVariantList = [
    "moon"
    "storm"
    "black"
    "float"
    "outline"
    "macos"
  ];
  iconVariantList = [
    "Dark-Cyan"
    "Dark"
    "Light"
    "Moon"
  ];
in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants lib.checkListOfEnum
  "${pname}: sizeVariants"
  sizeVariantList
  sizeVariants
  lib.checkListOfEnum
  "${pname}: themeVariants"
  themeVariantList
  themeVariants
  lib.checkListOfEnum
  "${pname}: tweakVariants"
  tweakVariantList
  tweakVariants
  lib.checkListOfEnum
  "${pname}: iconVariants"
  iconVariantList
  iconVariants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2025-10-23";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Tokyonight-GTK-Theme";
      rev = "6c340e058e84c1975a038a8e5d1e384477225dc0";
      hash = "sha256-7H2n9wTaW8Db1RejWK071ITV1j5KIuzfql0Tx9WT6zM=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    nativeBuildInputs = [
      gnome-shell
      sassc
    ];
    buildInputs = [ gnome-themes-extra ];

    dontBuild = true;

    passthru.updateScript = unstableGitUpdater { };

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      ./install.sh -n Tokyonight \
      ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      -d "$out/share/themes"
      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "Tokyonight-${v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';

    meta = {
      description = "GTK theme based on the Tokyo Night colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [
        garaiza-93
        d3vil0p3r
      ];
      platforms = lib.platforms.unix;
    };
  }
