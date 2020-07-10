{ stdenv
, fetchurl
, fetchpatch
, gnome-icon-theme
, gnome3
, gtk-engine-murrine
, gtk3
, hicolor-icon-theme
, humanity-icon-theme
, python2Packages
}:

stdenv.mkDerivation rec {
  pname = "ubuntu-themes";
  version = "19.04";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/${pname}_${version}.orig.tar.gz";
    sha256 = "1dy2dmiq2dj80nl2y4mf4ks0c7qmmnpk25wzv2rynwa3s2gkxgih";
  };

  nativeBuildInputs = [
    gtk3
    python2Packages.python
  ];

  propagatedBuildInputs = [
    gnome-icon-theme
    gnome3.adwaita-icon-theme
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
    cp -a suru-icons        $out/share/icons
    cp -a ubuntu-mobile     $out/share/icons
    cp -a ubuntu-mono-dark  $out/share/icons
    cp -a ubuntu-mono-light $out/share/icons

    mv $out/share/icons/{suru-icons,suru}

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp -a distributor-logo.png $out/share/icons/hicolor/48x48/apps

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Ubuntu monochrome and Suru icon themes, Ambiance and Radiance themes, and Ubuntu artwork";
    homepage = "https://launchpad.net/ubuntu-themes";
    license = with licenses; [ cc-by-sa-40 gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
