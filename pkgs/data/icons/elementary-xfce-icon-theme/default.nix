{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "elementary-xfce-icon-theme-${version}";
  version = "2017-11-28";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "b5cc6f044ed24e388ed2fffed1d02f43ce76f5e6";
    sha256 = "15n28f2pw8b0y5pi8ydahg31v6hhh7zvpvymi8jaafdc9bn18z3y";
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
