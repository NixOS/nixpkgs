{ stdenv
, lib
, fetchurl
, pkg-config
, gi-docgen
, gobject-introspection
, meson
, ninja
, gjs
, glib
, lua5_1
, python3
, spidermonkey_102
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libpeas";
  version = "1.99.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-BODO8oG8kCYo4IU+0+e8KOSrYxFjgUCb/UDBrEvdMnQ=";
  };

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
  ];

  propagatedBuildInputs = [
    # Required by libpeas-2.pc
    gobject-introspection
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  # Direct usage in `loaders/gjs/peas-plugin-loader-gjs.cpp`.
  # https://gitlab.gnome.org/GNOME/libpeas/-/issues/51
  env.NIX_CFLAGS_COMPILE = "-I${spidermonkey_102.dev}/include/mozjs-102";

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
