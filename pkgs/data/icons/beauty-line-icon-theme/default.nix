{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  breeze-icons,
  gtk3,
  gnome-icon-theme,
  hicolor-icon-theme,
  mint-x-icons,
  pantheon,
  jdupes,
}:

stdenvNoCC.mkDerivation rec {
  pname = "BeautyLine";
  version = "2.4";

  src = fetchFromGitLab {
    owner = "garuda-linux";
    repo = "themes-and-settings/artwork/beautyline";
    rev = "0df6f5df71c19496f9a873f8a52fbb5e84e95b12";
    hash = "sha256-SsYW4H1qam7kQJ3E4/vHJJOv2E4Pdk3itGncWa6YTqw=";
  };

  nativeBuildInputs = [
    jdupes
    gtk3
  ];

  # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
    mint-x-icons
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/${pname}
    cp -r * $out/share/icons/${pname}/
    gtk-update-icon-cache $out/share/icons/${pname}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "BeautyLine icon theme";
    homepage = "https://www.gnome-look.org/p/1425426/";
    platforms = platforms.linux;
    license = [ licenses.publicDomain ];
    maintainers = with maintainers; [ lwb-2021 ];
  };
}
