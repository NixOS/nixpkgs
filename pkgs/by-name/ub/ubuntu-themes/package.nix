{
  lib,
  stdenv,
  fetchurl,
  gnome-icon-theme,
  adwaita-icon-theme,
  gtk-engine-murrine,
  gtk3,
  hicolor-icon-theme,
  humanity-icon-theme,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "ubuntu-themes";
  version = "24.04";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/ubuntu-themes/${version}-0ubuntu1/ubuntu-themes_${version}.orig.tar.gz";
    hash = "sha256-/SMwwDaSUe86SXNe7U9Sh7SzzlC4yOXVA+urAIxeDxk=";
  };

  nativeBuildInputs = [
    gtk3
    python3Packages.python
  ];

  propagatedBuildInputs = [
    gnome-icon-theme
    adwaita-icon-theme
    humanity-icon-theme
    hicolor-icon-theme
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -a Ambiance $out/share/themes
    cp -a Radiance $out/share/themes

    mkdir -p $out/share/icons
    cp -a LoginIcons        $out/share/icons
    cp -a ubuntu-mobile     $out/share/icons
    cp -a ubuntu-mono-dark  $out/share/icons
    cp -a ubuntu-mono-light $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp -a distributor-logo.png $out/share/icons/hicolor/48x48/apps

    runHook postInstall
  '';

  dontCheckForBrokenSymlinks = true;

  meta = {
    description = "Ubuntu monochrome and Suru icon themes, Ambiance and Radiance themes, and Ubuntu artwork";
    homepage = "https://launchpad.net/ubuntu-themes";
    license = with lib.licenses; [
      cc-by-sa-40
      gpl3
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
}
