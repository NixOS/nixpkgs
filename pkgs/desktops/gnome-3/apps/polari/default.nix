{ stdenv, itstool, fetchurl, gdk_pixbuf, adwaita-icon-theme
, telepathy-glib, gjs, meson, ninja, gettext, telepathy-idle, libxml2, desktop-file-utils
, pkgconfig, gtk3, glib, libsecret, libsoup, gobjectIntrospection, appstream-glib
, gnome3, wrapGAppsHook, telepathy-logger, gspell }:

let
  pname = "polari";
  version = "3.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1066j1lbrkpcxhvrg3gcv7gv8dzqv5ny9qi9dnm8r1dsx2hil9yc";
  };

  propagatedUserEnvPkgs = [ telepathy-idle telepathy-logger ];

  nativeBuildInputs = [
    meson ninja pkgconfig itstool gettext wrapGAppsHook libxml2
    desktop-file-utils gobjectIntrospection appstream-glib
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
