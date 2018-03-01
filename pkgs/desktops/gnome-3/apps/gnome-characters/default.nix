{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, gobjectIntrospection, gjs, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "gnome-characters-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "69d0218b4ce16451bef0e6ee9f9f18f5b7851aa3a758b13315d592b077374f7b";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-characters"; attrPath = "gnome3.gnome-characters"; };
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool ];
  buildInputs = [
    gtk3 gjs gdk_pixbuf gobjectIntrospection
    librsvg gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Design/Apps/CharacterMap;
    description = "Simple utility application to find and insert unusual characters";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
