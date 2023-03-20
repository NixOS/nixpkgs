{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk4
, desktop-file-utils
, wrapGAppsHook4
, gettext
, itstool
, libadwaita
, libxml2
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_43
, systemd
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "M6k7l17CfISHglBIqnuK99XCNWWrz3t0yQKrez7CCGE=";
  };

  patches = [
    # Remove GTK 3 depndency
    # https://gitlab.gnome.org/GNOME/gnome-logs/-/merge_requests/46
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-logs/-/commit/32193a1385b95012bc8e7007ada89566bd63697d.patch";
      sha256 = "5WsTnfVpWZquU65pSLnk2M6VnY+qQPUi7A0cqMmzfrU=";
      postFetch = ''
        substituteInPlace "$out" --replace "43.1" "43.0"
      '';
    })
  ];

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
    homepage = "https://wiki.gnome.org/Apps/Logs";
    description = "A log viewer for the systemd journal";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
