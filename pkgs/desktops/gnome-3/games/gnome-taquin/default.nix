{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-taquin-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-taquin/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "096a32nhcz243na56iq2wxixd4f3lbj33a5h718r3j6yppqazjx9";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-taquin"; attrPath = "gnome3.gnome-taquin"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook librsvg libcanberra-gtk3
    intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Taquin;
    description = "Move tiles so that they reach their places";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
