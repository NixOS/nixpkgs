{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk3
, wrapGAppsHook
, gettext
, itstool
, libhandy
, libxml2
, libxslt
, docbook_xsl
, docbook_xml_dtd_43
, systemd
, python3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "TV5FFp1r9DkC16npoHk8kW65LaumuoWzXI629nLNq9c=";
  };

  nativeBuildInputs = [
    python3
    meson
    ninja
    pkg-config
    wrapGAppsHook
    gettext
    itstool
    libxml2
    libxslt
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
    systemd
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dman=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome.gnome-logs";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Logs";
    description = "A log viewer for the systemd journal";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
