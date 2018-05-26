{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "elementary-xfce-icon-theme-${version}";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "elementary-xfce-${version}";
    sha256 = "1hgbw9wwsgrbrs8lgdhba2m8m1cvqbcy27b87kjws6jsa00f5hx6";
  };

  nativeBuildInputs = [ gtk3 hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons
    mv elementary-xfce* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Elementary icons for Xfce and other GTK+ desktops like GNOME";
    homepage = https://github.com/shimmerproject/elementary-xfce;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ davidak ];
  };
}
