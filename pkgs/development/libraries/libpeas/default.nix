{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  gettext,
  gi-docgen,
  gnome,
  glib,
  gtk3,
  gobject-introspection,
  python3,
  ncurses,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "1.36.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libpeas/${lib.versions.majorMinor version}/libpeas-${version}.tar.xz";
    sha256 = "KXy5wszNjoYXYj0aPoQVtFMLjlqJPjUnu/0e3RMje0w=";
  };

  patches = [
    # Make PyGObject’s gi library available.
    (replaceVars ./fix-paths.patch {
      pythonPaths = lib.concatMapStringsSep ", " (pkg: "'${pkg}/${python3.sitePackages}'") [
        python3.pkgs.pygobject3
      ];
    })

    # girepository: port libpeas ABI to girepository
    # https://gitlab.gnome.org/GNOME/libpeas/-/issues/58
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libpeas/-/commit/73e25b6059d2fdc090a3feb8341ff902c3ec0d16.patch";
      hash = "sha256-xNp/DbLV2mdMiUALdEWE4ssyD3krWmzmJIwgStsNShM=";
    })
    # build: handle depending on development releases of GLib
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libpeas/-/commit/4613accc2e22395bb77bdf612fcdf90bf65f230f.patch";
      hash = "sha256-VGPLDswH3St/SzS19iHr5dA/ywzDsXhd7FMUg4rII9U=";
    })
  ];

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
    wrapGAppsHook3
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
      packageName = "libpeas";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "GObject-based plugins engine";
    mainProgram = "peas-demo";
    homepage = "https://gitlab.gnome.org/GNOME/libpeas";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
}
