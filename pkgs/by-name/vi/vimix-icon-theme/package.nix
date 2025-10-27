{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  gtk3,
  hicolor-icon-theme,
  jdupes,
  colorVariants ? [ ], # default: all
}:

let
  pname = "vimix-icon-theme";

in
lib.checkListOfEnum "${pname}: color variants"
  [
    "standard"
    "Amethyst"
    "Beryl"
    "Doder"
    "Ruby"
    "Jade"
    "Black"
    "White"
  ]
  colorVariants

  stdenvNoCC.mkDerivation
  rec {
    inherit pname;
    version = "2025.02.10";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "vimix-icon-theme";
      rev = version;
      hash = "sha256-HNwEqp6G9nZDIJo9b6FD4d5NSXUx523enENM0NVwviA=";
    };

    nativeBuildInputs = [
      gtk3
      jdupes
    ];

    propagatedBuildInputs = [
      hicolor-icon-theme
    ];

    dontDropIconThemeCache = true;

    # These fixup steps are slow and unnecessary for this package
    dontPatchELF = true;
    dontRewriteSymlinks = true;

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      ./install.sh \
        ${if colorVariants != [ ] then toString colorVariants else "-a"} \
        -d $out/share/icons

      # replace duplicate files with symlinks
      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater { };

    meta = with lib; {
      description = "Material Design icon theme based on Paper icon theme";
      homepage = "https://github.com/vinceliuice/vimix-icon-theme";
      license = with licenses; [ cc-by-sa-40 ];
      platforms = platforms.linux;
      maintainers = with maintainers; [ romildo ];
    };
  }
