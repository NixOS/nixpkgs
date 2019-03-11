{ stdenv, gettext, fetchurl, evolution-data-server
, pkgconfig, libxslt, docbook_xsl, docbook_xml_dtd_42, python3, gtk3, glib, cheese
, libchamplain, clutter-gtk, geocode-glib, gnome-desktop, gnome-online-accounts
, wrapGAppsHook, folks, libxml2, gnome3, telepathy-glib
, vala, meson, ninja }:

let
  version = "3.30.2";
in stdenv.mkDerivation rec {
  name = "gnome-contacts-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1b0pkdwz9yqcv82zzdf76rs2w3wa5zli8pka09wnahikx1ykk43h";
  };

  propagatedUserEnvPkgs = [ evolution-data-server ];

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext libxslt docbook_xsl docbook_xml_dtd_42 python3 wrapGAppsHook
  ];

  buildInputs = [
    gtk3 glib evolution-data-server gnome3.gsettings-desktop-schemas
    folks gnome-desktop telepathy-glib
    libxml2 gnome-online-accounts cheese
    gnome3.adwaita-icon-theme libchamplain clutter-gtk geocode-glib
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  # In file included from src/gnome-contacts@exe/contacts-avatar-selector.c:30:0:
  # /nix/store/*-cheese-3.28.0/include/cheese/cheese-widget.h:26:10: fatal error: clutter-gtk/clutter-gtk.h: No such file or directory
  #  #include <clutter-gtk/clutter-gtk.h>
  #           ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  NIX_CFLAGS_COMPILE = "-I${stdenv.lib.getDev clutter-gtk}/include/clutter-gtk-1.0";

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-contacts";
      attrPath = "gnome3.gnome-contacts";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Contacts;
    description = "GNOME’s integrated address book";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
