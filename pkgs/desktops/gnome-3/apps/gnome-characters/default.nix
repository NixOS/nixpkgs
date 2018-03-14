{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gnome3, glib, gtk3, pango, wrapGAppsHook
, gobjectIntrospection, gjs, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "gnome-characters-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "14q92ysg7krawxlwv6ymgsxz2plk81wgfz6knlma7lm13jsczmf0";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-characters";
      attrPath = "gnome3.gnome-characters";
    };
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook gobjectIntrospection ];
  buildInputs = [ glib gtk3 gjs pango gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme ];

  mesonFlags = [
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/services"
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Design/Apps/CharacterMap;
    description = "Simple utility application to find and insert unusual characters";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
