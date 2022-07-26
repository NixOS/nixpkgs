{ lib, stdenvNoCC, fetchzip, breeze-icons, gtk3, gnome-icon-theme, hicolor-icon-theme, mint-x-icons, pantheon }:

stdenvNoCC.mkDerivation rec {
  pname = "BeautyLine";
  version = "0.0.1";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "https://github.com/gvolpe/BeautyLine/releases/download/${version}/BeautyLine.tar.gz";
    sha256 = "030bjk333fr9wm1nc740q8i31rfsgf3vg6cvz36xnvavx3q363l7";
  };

  nativeBuildInputs = [ gtk3 ];

  # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
    mint-x-icons
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons/${pname}
    cp -r * $out/share/icons/${pname}/
    gtk-update-icon-cache $out/share/icons/${pname}
  '';

  meta = with lib; {
    description = "BeautyLine icon theme";
    homepage = "https://www.gnome-look.org/p/1425426/";
    platforms = platforms.linux;
    license = [ licenses.publicDomain ];
    maintainers = with maintainers; [ gvolpe ];
  };
}
