{ lib
, stdenvNoCC
, fetchFromGitHub
, gitUpdater
, gtk3
, hicolor-icon-theme
, jdupes
, schemeVariants ? []
, colorVariants ? [] # default is blue
}:

let
  pname = "colloid-icon-theme";

in
lib.checkListOfEnum "${pname}: scheme variants" [ "default" "nord" "dracula" "gruvbox" "everforest" "catppuccin" "all" ] schemeVariants
lib.checkListOfEnum "${pname}: color variants" [ "default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "grey" "all" ] colorVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "2024-02-28";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    hash = "sha256-bTN6x3t88yBL4WsPfOJIiNGWTywdIVi7E2VJKgMzEso=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
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

    name= ./install.sh \
      ${lib.optionalString (schemeVariants != []) ("--scheme " + builtins.toString schemeVariants)} \
      ${lib.optionalString (colorVariants != []) ("--theme " + builtins.toString colorVariants)} \
      --dest $out/share/icons

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Colloid icon theme";
    homepage = "https://github.com/vinceliuice/colloid-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
