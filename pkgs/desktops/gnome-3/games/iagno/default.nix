{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf, librsvg, wrapGAppsHook
, intltool, itstool, libcanberra-gtk3, libxml2, dconf }:

stdenv.mkDerivation rec {
  name = "iagno-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "12haq1vgrr6wf970rja55rcg0352sm0i3l5z7gj0ipr2isv8506x";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "iagno"; attrPath = "gnome3.iagno"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  dconf libxml2 libcanberra-gtk3 wrapGAppsHook itstool intltool ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Iagno;
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
