{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  adwaita-icon-theme,
  libsForQt5,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  gitUpdater,
  allColorVariants ? false,
  circularFolder ? false,
  colorVariants ? [ ], # default is standard
}:

lib.checkListOfEnum "tela-circle-icon-theme: color variants"
  [
    "standard"
    "black"
    "blue"
    "brown"
    "green"
    "grey"
    "orange"
    "pink"
    "purple"
    "red"
    "yellow"
    "manjaro"
    "ubuntu"
    "dracula"
    "nord"
  ]
  colorVariants

  stdenvNoCC.mkDerivation
  rec {
    pname = "tela-circle-icon-theme";
    version = "2025-02-10";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "tela-circle-icon-theme";
      tag = version;
      hash = "sha256-5Kqf6QNM+/JGGp2H3Vcl69Vh1iZYPq3HJxhvSH6k+eQ=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    propagatedBuildInputs = [
      adwaita-icon-theme
      libsForQt5.breeze-icons
      hicolor-icon-theme
    ];

    dontDropIconThemeCache = true;

    # These fixup steps are slow and unnecessary for this package.
    # Package may install almost 400 000 small files.
    dontPatchELF = true;
    dontRewriteSymlinks = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh -d $out/share/icons \
        ${lib.optionalString circularFolder "-c"} \
        ${if allColorVariants then "-a" else toString colorVariants}

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = {
      description = "Flat and colorful personality icon theme";
      homepage = "https://github.com/vinceliuice/Tela-circle-icon-theme";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux; # darwin use case-insensitive filesystems that cause hash mismatches
      maintainers = with lib.maintainers; [ romildo ];
    };
  }
