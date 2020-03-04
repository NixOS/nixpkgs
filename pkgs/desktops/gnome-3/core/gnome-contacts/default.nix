{ stdenv, gettext, fetchurl, evolution-data-server, fetchpatch
, pkgconfig, libxslt, docbook_xsl, docbook_xml_dtd_42, python3, gtk3, glib, cheese
, libchamplain, clutter-gtk, geocode-glib, gnome-desktop, gnome-online-accounts
, wrapGAppsHook, folks, libxml2, gnome3, telepathy-glib
, vala, meson, ninja, libhandy, gsettings-desktop-schemas }:

let
  version = "3.34.1";
in stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  inherit version;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1jqw5yrypvjxzgg70vjbryylwx06amg6sg85mqi14a97xbccg0qa";
  };

  propagatedUserEnvPkgs = [ evolution-data-server ];

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext libxslt docbook_xsl docbook_xml_dtd_42 python3 wrapGAppsHook
  ];

  buildInputs = [
    gtk3 glib evolution-data-server gsettings-desktop-schemas
    folks gnome-desktop telepathy-glib libhandy
    libxml2 gnome-online-accounts cheese
    gnome3.adwaita-icon-theme libchamplain clutter-gtk geocode-glib
  ];

  mesonFlags = [
    "-Dtelepathy=true"
  ];

  patches = [
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
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
