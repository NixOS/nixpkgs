{ stdenv, itstool, fetchurl, gdk_pixbuf, adwaita-icon-theme
, telepathy-glib, gjs, meson, ninja, gettext, telepathy-idle, libxml2, desktop-file-utils
, pkgconfig, gtk3, glib, libsecret, libsoup, gobject-introspection, appstream-glib
, gnome3, wrapGAppsHook, telepathy-logger, gspell, gsettings-desktop-schemas }:

let
  pname = "polari";
  version = "3.32.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0z2dxj1hd798jn79y9a7lkb77lm8l7y5fsqh9g6lbr7pnmg559yk";
  };

  propagatedUserEnvPkgs = [ telepathy-idle telepathy-logger ];

  nativeBuildInputs = [
    meson ninja pkgconfig itstool gettext wrapGAppsHook libxml2
    desktop-file-utils gobject-introspection appstream-glib
  ];

  buildInputs = [
    gtk3 glib adwaita-icon-theme gsettings-desktop-schemas
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
