{ stdenv, itstool, fetchurl, fetchpatch, gdk_pixbuf, adwaita-icon-theme
, telepathy-glib, gjs, meson, ninja, gettext, telepathy-idle, libxml2, desktop-file-utils
, pkgconfig, gtk3, glib, libsecret, libsoup, gobjectIntrospection, appstream-glib
, gnome3, wrapGAppsHook, telepathy-logger, gspell }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ telepathy-idle telepathy-logger ];

  nativeBuildInputs = [ meson ninja pkgconfig itstool gettext wrapGAppsHook libxml2
                        desktop-file-utils gobjectIntrospection appstream-glib ];
  buildInputs = [ gtk3 glib adwaita-icon-theme gnome3.gsettings-desktop-schemas
                  telepathy-glib telepathy-logger gjs gspell gdk_pixbuf libsecret libsoup ];

  patches = [
    (fetchpatch {
      url = https://gitlab.gnome.org/jtojnar/polari/commit/a6733a6ad95eac1813e7b18e3d0018a22ee7a377.diff;
      sha256 = "0f5ll49h5w0477lkh67kaa2j83z376z1jk7z3i2v7cq4d3hi5lf9";
    })
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Polari;
    description = "IRC chat client designed to integrate with the GNOME desktop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
