{ lib, stdenv
, meson
, ninja
, gettext
, fetchurl
, pkg-config
, wrapGAppsHook
, itstool
, desktop-file-utils
, python3
, glib
, gtk3
, evolution-data-server
, gnome-online-accounts
, json-glib
, libuuid
, curl
, libhandy
, webkitgtk
, gnome3
, libxml2
, gsettings-desktop-schemas
, tracker
}:

stdenv.mkDerivation rec {
  pname = "gnome-notes";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${lib.versions.major version}/bijiben-${version}.tar.xz";
    sha256 = "098g247dlwddjvcd56ld3iak3bfb0d159avr9vjrd332a720mymf";
  };

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    desktop-file-utils
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libuuid
    curl
    libhandy
    webkitgtk
    tracker
    gnome-online-accounts
    gsettings-desktop-schemas
    evolution-data-server
    gnome3.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Dupdate_mimedb=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "bijiben";
      attrPath = "gnome3.gnome-notes";
    };
  };

  meta = with lib; {
    description = "Note editor designed to remain simple to use";
    homepage = "https://wiki.gnome.org/Apps/Notes";
    license = licenses.gpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
