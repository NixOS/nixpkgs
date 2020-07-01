{ stdenv, gettext, fetchurl, evolution-data-server, fetchpatch
, pkgconfig, libxslt, docbook_xsl, docbook_xml_dtd_42, python3, gtk3, glib, cheese
, libchamplain, clutter-gtk, geocode-glib, gnome-desktop, gnome-online-accounts
, wrapGAppsHook, folks, libxml2, gnome3
, vala, meson, ninja, libhandy, gsettings-desktop-schemas
# , telepathy-glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  version = "3.36.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0qb2kgyk6f6wr129a0gzhvpy5wdjpwjbksxyfs6zxv183jl9s73z";
  };

  propagatedUserEnvPkgs = [ evolution-data-server ];

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext libxslt docbook_xsl docbook_xml_dtd_42 python3 wrapGAppsHook
  ];

  buildInputs = [
    gtk3 glib evolution-data-server gsettings-desktop-schemas
    folks gnome-desktop libhandy
    libxml2 gnome-online-accounts cheese
    gnome3.adwaita-icon-theme libchamplain clutter-gtk geocode-glib
    # telepathy-glib 3.35.90 fails to build with telepathy
  ];

  mesonFlags = [
    # Upstream does not seem to maintain this properly: https://gitlab.gnome.org/GNOME/gnome-contacts/issues/103
    "-Dtelepathy=false"
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
    homepage = "https://wiki.gnome.org/Apps/Contacts";
    description = "GNOME’s integrated address book";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
