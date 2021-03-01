{ lib, stdenv, fetchFromGitHub , gtk3, breeze-icons, pantheon, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec  {
  pname = "flat-remix-icon-theme";
  version = "20200710";

  src = fetchFromGitHub  {
    owner = "daniruiz";
    repo = "flat-remix";
    rev = version;
    sha256 = "0rlrmgimvs9rrj64g5jn04jgyi7wmn2dnsk7ckmxk6p8cdfjd0hx";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    pantheon.elementary-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Flat-Remix* $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Flat remix is a pretty simple icon theme inspired on material design";
    homepage = "https://drasite.com/flat-remix";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ mschneider ];
  };
}
