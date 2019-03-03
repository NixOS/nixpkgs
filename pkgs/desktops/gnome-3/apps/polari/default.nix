{ stdenv, itstool, fetchurl, gdk_pixbuf, adwaita-icon-theme
, telepathy-glib, gjs, meson, ninja, gettext, telepathy-idle, libxml2, desktop-file-utils
, pkgconfig, gtk3, glib, libsecret, libsoup, gobject-introspection, appstream-glib
, gnome3, wrapGAppsHook, telepathy-logger, gspell }:

let
  pname = "polari";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1jq1xvk9a05x37g9w349f5q069cvg5lfbhxj88gpbnf4fyndnr70";
  };

  propagatedUserEnvPkgs = [ telepathy-idle telepathy-logger ];

  nativeBuildInputs = [
    meson ninja pkgconfig itstool gettext wrapGAppsHook libxml2
    desktop-file-utils gobject-introspection appstream-glib
  ];

  buildInputs = [
    gtk3 glib adwaita-icon-theme gnome3.gsettings-desktop-schemas
    telepathy-glib telepathy-logger gjs gspell gdk_pixbuf libsecret libsoup
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Polari;
    description = "IRC chat client designed to integrate with the GNOME desktop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
