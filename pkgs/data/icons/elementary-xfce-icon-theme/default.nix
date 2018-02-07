{ stdenv, fetchFromGitHub, gtk3, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "elementary-xfce-icon-theme-${version}";
  version = "2017-11-28";

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = "elementary-xfce";
    rev = "b5cc6f044ed24e388ed2fffed1d02f43ce76f5e6";
    sha256 = "15n28f2pw8b0y5pi8ydahg31v6hhh7zvpvymi8jaafdc9bn18z3y";
  };

  # fallback icon theme
  propagatedBuildInputs = [ hicolor_icon_theme ];

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' elementary-xfce{,-dark,-darker,-darkest} $out/share/icons/
  '';

  postInstall = ''
    for icons in "$out"/share/icons/*; do
      "${gtk3.out}/bin/gtk-update-icon-cache" "$icons"
    done
  '';

  meta = with stdenv.lib; {
    description = "Elementary icons for Xfce and other Gtk+ desktops like Gnome3";
    homepage = https://github.com/shimmerproject/elementary-xfce;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ davidak ];
  };
}
