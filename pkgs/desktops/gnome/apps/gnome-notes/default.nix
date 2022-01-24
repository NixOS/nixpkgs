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
, gnome
, libxml2
, gsettings-desktop-schemas
, tracker
}:

stdenv.mkDerivation rec {
  pname = "gnome-notes";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/bijiben/${lib.versions.major version}/bijiben-${version}.tar.xz";
    sha256 = "1gvvb2klkzbmyzwkjgmscdiqcl8lyz9b0rxb4igjz079csq6z805";
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
    gnome.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Dupdate_mimedb=false"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "bijiben";
      attrPath = "gnome.gnome-notes";
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
