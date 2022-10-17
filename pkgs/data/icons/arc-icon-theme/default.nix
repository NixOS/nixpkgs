{ lib, stdenvNoCC, fetchFromGitHub, autoreconfHook, gtk3, gnome, moka-icon-theme, gnome-icon-theme, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "arc-icon-theme";
  version = "2016-11-22";

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = pname;
    rev = "55a575386a412544c3ed2b5617a61f842ee4ec15";
    sha256 = "1ch3hp08qri93510hypzz6m2x4xgg2h15wvnhjwh1x1s1b7jvxjd";
  };

  nativeBuildInputs = [
    autoreconfHook
    gtk3
  ];

  propagatedBuildInputs = [
    moka-icon-theme
    gnome.adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postFixup = "gtk-update-icon-cache $out/share/icons/Arc";

  meta = with lib; {
    description = "Arc icon theme";
    homepage = "https://github.com/horst3180/arc-icon-theme";
    license = licenses.gpl3;
    # moka-icon-theme dependency is restricted to linux
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
