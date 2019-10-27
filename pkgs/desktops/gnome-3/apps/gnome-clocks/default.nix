{ stdenv, fetchurl
, meson, ninja, gettext, pkgconfig, wrapGAppsHook, itstool, desktop-file-utils
, vala, gobject-introspection, libxml2, gtk3, glib, gsound, sound-theme-freedesktop
, gsettings-desktop-schemas, adwaita-icon-theme, gnome-desktop, geocode-glib
, gnome3, gdk-pixbuf, geoclue2, libgweather }:

stdenv.mkDerivation rec {
  pname = "gnome-clocks";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0g7hjk55smhkd09hwa9kag3h5a12l494wj89w9smpdk3ghsmy6b1";
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
    gobject-introspection # for finding vapi files
  ];
  buildInputs = [
    gtk3 glib gsettings-desktop-schemas gdk-pixbuf adwaita-icon-theme
    gnome-desktop geocode-glib geoclue2 libgweather gsound
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Fallback sound theme
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
    )
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
