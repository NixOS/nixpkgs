{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, pkg-config
, desktop-file-utils
, appstream-glib
, libxslt
, libxml2
, gettext
, itstool
, wrapGAppsHook
, docbook_xsl
, docbook_xml_dtd_43
, gnome
, gtk3
, glib
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-dictionary";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1d8dhcfys788vv27v34i3s3x3jdvdi2kqn2a5p8c937a9hm0qr9f";
  };

  patches = [
    # Fix test dependencies with meson 0.57, can be removed on next bump
    # We need to explicitly depend on the generated files.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-dictionary/-/commit/87c026cfe4acbcfc62d15950f88a71d8d9678c7e.patch";
      sha256 = "tKesWeOK3OqOxrXm4dZvCZHHdTD7AQbYDjtYDCsLd3A=";
    })
    # Fix build with meson 0.61, can be removed on next bump
    # data/appdata/meson.build:3:5: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-dictionary/-/commit/cf3f8a67cd6f3059c555ed9cf0f5fba10abb7f68.patch";
      sha256 = "cIRM6ACqsnEo2JWYvr6EBye5o0BudugZMShCe1U5hz8=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    libxml2
    gettext
    itstool
    desktop-file-utils
    appstream-glib
    libxslt
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    gnome.adwaita-icon-theme
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-dictionary";
      attrPath = "gnome.gnome-dictionary";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Dictionary";
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
