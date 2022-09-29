{ stdenv
, lib
, fetchurl
, fetchpatch
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

  patches = [
    # meson: Remove redundant check for glib-mkenums
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-logs/-/commit/01386ce9a69652a00bdb163e569b51150ca8903e.diff";
      sha256 = "sha256-tJJEai4Jw8aVcyhsFTYILiUV1xhsysX/rleeLP13DVM=";
    })
    # meson: remove redundant check for pkg-config
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-logs/-/commit/ad350729a8b81f2c8eb2122de0956bb2199b48da.patch";
      sha256 = "sha256-5qGYyKM+B9XNZKytWH8K4QfSuBf7wpaPCWT6YIO5FGY=";
    })
  ];

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
    glib
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
