{ stdenv, gettext, fetchurl, evolution-data-server, fetchpatch
, pkgconfig, libxslt, docbook_xsl, docbook_xml_dtd_42, python3, gtk3, glib, cheese
, libchamplain, clutter-gtk, geocode-glib, gnome-desktop, gnome-online-accounts
, wrapGAppsHook, folks, libxml2, gnome3, telepathy-glib
, vala, meson, ninja, libhandy, gsettings-desktop-schemas }:

let
  version = "3.32.1";
in stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  inherit version;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17g1gh8yj58cfpdx69h2szivlbjgvv982kmhnkkh0i5bwj0zs2yy";
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
    # Fixes build with libhandy >= 0.0.10
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-contacts/commit/c5eee38cd2556403a640a0a4c11d36cbf9a5a798.patch";
      sha256 = "0s2cl7z6b0x3ky4y28yyxc9x5zp4r3vqmvbhz5m2fm6830fyjg13";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-contacts/commit/1f1500ca01098ffda6392f5ec9ce3a29a48a84b1.patch";
      sha256 = "082zaaj2l5cgr2qy145x8yknja87r0vpigrhidal40041kd5nldg";
    })
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
