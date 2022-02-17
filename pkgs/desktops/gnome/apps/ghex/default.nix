{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, gi-docgen
, meson
, ninja
, python3
, gnome
, desktop-file-utils
, appstream-glib
, gettext
, itstool
, libxml2
, gtk4
, glib
, atk
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "4.beta.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${version}/${pname}-${version}.tar.xz";
    sha256 = "sBS/9cY++uHLGCbLeex8ZW697JJn3dK+HaM6tHBdwJ4=";
  };

  patches = [
    # Fix build with -Werror=format-security
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/ghex/-/commit/3d35359f3a12b6abb4a3d8a12a0f39b7221be408.patch";
      sha256 = "4z9nUd+/eBOUGwl3MErse+FKLzGqtWKwkIzej57CnYk=";
    })
    # Build devhelp index.
    # https://gitlab.gnome.org/GNOME/ghex/-/merge_requests/25
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/ghex/-/commit/b26a7b1135ea2fe956a9bc0669b3b6ed818716c3.patch";
      sha256 = "nYjjxds9GNWkW/RhXEe5zJzPF4TnLMsCELEqYR4dXTk=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    gi-docgen
    python3
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    atk
    glib
  ];

  checkInputs = [
    appstream-glib
    desktop-file-utils
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "ghex";
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Ghex";
    description = "Hex editor for GNOME desktop environment";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
  };
}
