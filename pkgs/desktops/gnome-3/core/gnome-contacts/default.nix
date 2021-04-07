{ lib, stdenv
, gettext
, fetchurl
, evolution-data-server
, pkg-config
, libxslt
, docbook_xsl
, docbook_xml_dtd_42
, python3
, gtk3
, glib
, cheese
, libchamplain
, clutter-gtk
, geocode-glib
, gnome-desktop
, gnome-online-accounts
, wrapGAppsHook
, folks
, libxml2
, gnome3
, vala
, meson
, ninja
, libhandy
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hsq0dwxjahcaxnm1m4r1lync9k2fkwzybfmkchrmn95vqcwwvf9";
  };

  propagatedUserEnvPkgs = [
    evolution-data-server
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    glib
    evolution-data-server
    gsettings-desktop-schemas
    folks
    gnome-desktop
    libhandy
    libxml2
    gnome-online-accounts
    cheese
    gnome3.adwaita-icon-theme
    libchamplain
    clutter-gtk
    geocode-glib
  ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-contacts";
      attrPath = "gnome3.gnome-contacts";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Contacts";
    description = "GNOME’s integrated address book";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
