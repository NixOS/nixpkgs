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
, libgdata
, libxml2
, gnome
, vala
, meson
, ninja
, libhandy
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-contacts";
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-contacts/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "Y+MUm10UdbeiaYAFu191DzyApzVxcWDjnfjP3+v8zfA=";
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
    gnome.adwaita-icon-theme
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
    updateScript = gnome.updateScript {
      packageName = "gnome-contacts";
      attrPath = "gnome.gnome-contacts";
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
