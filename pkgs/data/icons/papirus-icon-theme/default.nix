{ lib, stdenv, fetchFromGitHub, gtk3, pantheon, breeze-icons, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "papirus-icon-theme";
  version = "20210302";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = pname;
    rev = version;
    sha256 = "0h1cja8qqlnddm92hkyhkyj5rqfj494v0pss2mg95qqkjijpcgd0";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    pantheon.elementary-icon-theme
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv {,e}Papirus* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Papirus icon theme";
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme";
    license = licenses.gpl3Only;
    # darwin gives hash mismatch in source, probably because of file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
