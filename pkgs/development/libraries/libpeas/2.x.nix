{ stdenv
, lib
, fetchurl
, substituteAll
, pkg-config
, gi-docgen
, gobject-introspection
, meson
, ninja
, gjs
, glib
, lua5_1
, python3
, spidermonkey_115
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "2.0.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-ndwdUfOGY9pN9SFjBRt7LOo6JCz67p9afhQPB4TIqnc=";
  };

  patches = [
    # Make PyGObject’s gi library available.
    (substituteAll {
      src = ./fix-paths.patch;
      pythonPaths = lib.concatMapStringsSep ", " (pkg: "'${pkg}/${python3.sitePackages}'") [
        python3.pkgs.pygobject3
      ];
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gjs
    glib
    lua5_1
    lua5_1.pkgs.lgi
    python3
    python3.pkgs.pygobject3
    spidermonkey_115
  ];

  propagatedBuildInputs = [
    # Required by libpeas-2.pc
    gobject-introspection
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    # Checks lua51 and lua5.1 executable but we have non of them.
    substituteInPlace meson.build --replace \
      "find_program('lua51', required: false)" \
      "find_program('lua', required: false)"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libpeas2";
      packageName = "libpeas";
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
