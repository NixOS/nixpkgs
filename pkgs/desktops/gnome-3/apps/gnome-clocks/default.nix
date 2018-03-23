{ stdenv, fetchurl
, meson, ninja, gettext, pkgconfig, wrapGAppsHook, itstool, desktop-file-utils
, vala, gobjectIntrospection, libxml2, gtk3, glib, gsound
, gnome3, gdk_pixbuf, geoclue2, libgweather }:

stdenv.mkDerivation rec {
  name = "gnome-clocks-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1dd739vchb592mck1dia2hkywn4213cpramyqzgmlmwv8z80p3nl";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-clocks";
      attrPath = "gnome3.gnome-clocks";
    };
  };

  doCheck = true;

  nativeBuildInputs = [
    vala meson ninja pkgconfig gettext itstool wrapGAppsHook desktop-file-utils libxml2
    gobjectIntrospection # for finding vapi files
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings-desktop-schemas gdk_pixbuf gnome3.defaultIconTheme
    gnome3.gnome-desktop gnome3.geocode-glib geoclue2 libgweather gsound
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
