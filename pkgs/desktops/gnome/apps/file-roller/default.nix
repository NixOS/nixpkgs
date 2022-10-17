{ lib
, stdenv
, fetchurl
, fetchpatch
, desktop-file-utils
, gettext
, glibcLocales
, itstool
, libxml2
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, cpio
, glib
, gnome
, gtk3
, libhandy
, json-glib
, libarchive
, libportal-gtk3
, nautilus
}:

stdenv.mkDerivation rec {
  pname = "file-roller";
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${lib.versions.major version}/file-roller-${version}.tar.xz";
    sha256 = "KYcp/b252oEywLvGCQdRfWVoWwVhiuBRZzNeZIT1c6E=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glibcLocales
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    cpio
    glib
    gtk3
    libhandy
    json-glib
    libarchive
    libportal-gtk3
    nautilus
  ];

  postPatch = ''
    patchShebangs data/set-mime-type-entry.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "file-roller";
      attrPath = "gnome.file-roller";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/FileRoller";
    description = "Archive manager for the GNOME desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members ++ teams.pantheon.members;
  };
}
