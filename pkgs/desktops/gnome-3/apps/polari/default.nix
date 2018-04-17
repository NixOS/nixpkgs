{ stdenv, itstool, fetchurl, fetchpatch, gdk_pixbuf, adwaita-icon-theme
, telepathy-glib, gjs, meson, ninja, gettext, telepathy-idle, libxml2, desktop-file-utils
, pkgconfig, gtk3, glib, libsecret, libsoup, gobjectIntrospection, appstream-glib
, gnome3, wrapGAppsHook, telepathy-logger, gspell }:

let
  pname = "polari";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "08zgdqrnxl752nv0gac1k7wvjd4j7h5n4c0flrq7q337p40k3dd5";
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
