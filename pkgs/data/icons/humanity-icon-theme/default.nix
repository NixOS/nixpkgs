{ lib, stdenvNoCC, fetchurl, gtk3, gnome, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "humanity-icon-theme";
  version = "0.6.16";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/+archive/primary/+files/${pname}_${version}.tar.xz";
    sha256 = "sha256-AyHl4zMyFE2/5Cui3Y/SB1yEUuyafDdybFPrafo4Ki0=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    gnome.adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Humanity* $out/share/icons
    rm $out/share/icons/*/{AUTHORS,CONTRIBUTORS,COPYING}

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Humanity icons from Ubuntu";
    homepage = "https://launchpad.net/humanity/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
