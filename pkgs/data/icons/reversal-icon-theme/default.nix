{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, jdupes
, adwaita-icon-theme
, hicolor-icon-theme
, numix-icon-theme-circle
, gitUpdater
, allColorVariants ? false
, colorVariants ? []
}:

let
  pname = "reversal-icon-theme";
in
lib.checkListOfEnum "${pname}: color variants" [ "-blue" "-red" "-pink" "-purple" "-green" "-orange" "-brown" "-grey" "-black" "-cyan" ] colorVariants

stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "unstable-2023-05-13";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = pname;
    rev = "bdae2ea365731b25a869fc2c8c6a1fb849eaf5b2";
    hash = "sha256-Cd+1ggyS+Y2Sk8w5zifc4IFOwbFrbjL6S6awES/W0EE=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
    numix-icon-theme-circle
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package.
  # Package may install many small files.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons

    name= ./install.sh \
      ${if allColorVariants then "-a" else builtins.toString colorVariants} \
      -d $out/share/icons

    rm $out/share/icons/*/{AUTHORS,COPYING}

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Colorful Design Rectangle icon theme";
    homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
