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
, wrapGAppsHook4
, cpio
, glib
, gnome
, gtk4
, libadwaita
, libhandy
, json-glib
, libarchive
, libportal-gtk4
, nautilus
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "file-roller";
  version = "44.3";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${lib.versions.major finalAttrs.version}/file-roller-${finalAttrs.version}.tar.xz";
    hash = "sha256-BMinRiX+yEJn/exAMGr7QQS9My2FBh4NNtSrBTOt+ko=";
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
    wrapGAppsHook4
  ];

  buildInputs = [
    cpio
    glib
    gtk4
    libadwaita
    libhandy
    json-glib
    libarchive
    libportal-gtk4
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
    homepage = "https://gitlab.gnome.org/GNOME/file-roller";
    description = "Archive manager for the GNOME desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members ++ teams.pantheon.members;
    mainProgram = "file-roller";
  };
})
