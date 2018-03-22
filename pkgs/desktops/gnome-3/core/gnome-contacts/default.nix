{ stdenv, gettext, fetchurl, evolution-data-server
, pkgconfig, libxslt, docbook_xsl, docbook_xml_dtd_42, gtk3, glib, cheese
, libchamplain, clutter-gtk, geocode-glib, gnome-desktop, gnome-online-accounts
, wrapGAppsHook, folks, libxml2, gnome3, telepathy-glib
, vala, meson, ninja }:

let
  version = "3.26.1";
in stdenv.mkDerivation rec {
  name = "gnome-contacts-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1jszv4b8rc5q8r460wb7qppvm1ssj4733b4z2vyavc95g00ik286";
  };

  propagatedUserEnvPkgs = [ evolution-data-server ];

  nativeBuildInputs = [
    meson ninja pkgconfig vala gettext libxslt docbook_xsl docbook_xml_dtd_42 wrapGAppsHook
  ];

  buildInputs = [
    gtk3 glib evolution-data-server gnome3.gsettings-desktop-schemas
    folks gnome-desktop telepathy-glib
    libxml2 gnome-online-accounts cheese
    gnome3.defaultIconTheme libchamplain clutter-gtk geocode-glib
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

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
