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
, libadwaita
, glib
, atk
, gobject-introspection
, vala
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "43.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "pUuUPv5CAQqcEuTc2ts3e/NslMOAB3i4Uww6g0QJ3Mc=";
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
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    atk
    glib
  ];

  nativeCheckInputs = [
    appstream-glib
    desktop-file-utils
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
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
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
  };
}
