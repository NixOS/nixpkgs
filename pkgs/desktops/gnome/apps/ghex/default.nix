{ stdenv
, lib
, fetchurl
, pkg-config
, gi-docgen
, meson
, ninja
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
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "42.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "rdQPirJJIdsw0nvljwAnMgGXfYf9yNeezq36iw41Te8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    wrapGAppsHook4
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
  ] ++ lib.optionals stdenv.isDarwin [
    # mremap does not exist on darwin
    "-Dmmap-buffer-backend=false"
  ];

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
