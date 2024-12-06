{ stdenv
, lib
, fetchurl
, substituteAll
, pkg-config
, gi-docgen
, gobject-introspection
, meson
, ninja
, vala
, gjs
, glib
, lua5_1
, python3
, spidermonkey_128
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "2.0.5";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-N28vc9cxtU4T3bqx2Rtjgs9qmAUk3vRN9irdFUid5t0=";
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
    vala
  ];

  buildInputs = [
    gjs
    glib
    lua5_1
    lua5_1.pkgs.lgi
    python3
    python3.pkgs.pygobject3
    spidermonkey_128
  ];

  propagatedBuildInputs = [
    # Required by libpeas-2.pc
    gobject-introspection
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dvapi=true"
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
    description = "GObject-based plugins engine";
    homepage = "https://gitlab.gnome.org/GNOME/libpeas";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
