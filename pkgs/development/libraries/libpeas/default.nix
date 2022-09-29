{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, gi-docgen
, gnome
, glib
, gtk3
, gobject-introspection
, python3
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "1.32.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1iVSD6AuiXcCmyRq5Dm8IYloll8egtYSIItxPx3MPQ4=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    ncurses
    python3
    python3.pkgs.pygobject3
  ];

  propagatedBuildInputs = [
    # Required by libpeas-1.0.pc
    gobject-introspection
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A GObject-based plugins engine";
    homepage = "https://wiki.gnome.org/Projects/Libpeas";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
