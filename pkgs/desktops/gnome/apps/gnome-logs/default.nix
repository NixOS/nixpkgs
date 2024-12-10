{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gnome,
  glib,
  gtk4,
  desktop-file-utils,
  wrapGAppsHook4,
  gettext,
  itstool,
  libadwaita,
  libxml2,
  libxslt,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  systemd,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-sooG6lyYvRfyhztQfwhbDKDemBATZhH08u6wmGFOzlI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    itstool
    libxml2
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    glib
    gtk4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    systemd
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dman=true"
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome.gnome-logs";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Logs/";
    description = "A log viewer for the systemd journal";
    mainProgram = "gnome-logs";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
