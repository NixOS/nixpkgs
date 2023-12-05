{ stdenv
, lib
, intltool
, fetchFromGitLab
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, python3
, gtk3
, pcre2
, glib
, desktop-file-utils
, gtk-doc
, wrapGAppsHook
, itstool
, libxml2
, yelp-tools
, docbook_xsl
, docbook_xml_dtd_412
, gsettings-desktop-schemas
, unzip
, unicode-character-database
, unihan-database
, runCommand
, symlinkJoin
, gobject-introspection
, gitUpdater
}:

let
  # TODO: make upstream patch allowing to use the uncompressed file,
  # preferably from XDG_DATA_DIRS.
  # https://gitlab.gnome.org/GNOME/gucharmap/issues/13
  unihanZip = runCommand "unihan" {} ''
    mkdir -p $out/share/unicode
    ln -s ${unihan-database.src} $out/share/unicode/Unihan.zip
  '';
  ucd = symlinkJoin {
    name = "ucd+unihan";
    paths = [
      unihanZip
      unicode-character-database
    ];
  };
in stdenv.mkDerivation rec {
  pname = "gucharmap";
  version = "15.1.2";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gucharmap";
    rev = version;
    sha256 = "sha256-tvFw2k5xCl+QE6cHvLj5KKdYFSghN7PVgHPmd27wh7k=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
    unzip
    intltool
    itstool
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    yelp-tools
    libxml2
    desktop-file-utils
    gobject-introspection
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    pcre2
  ];

  mesonFlags = [
    "-Ducd_path=${ucd}/share/unicode"
    "-Dvapi=false"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      data/meson_desktopfile.py \
      gucharmap/gen-guch-unicode-tables.pl
  '';

  passthru = {
    updateScript = gitUpdater {
    };
  };

  meta = with lib; {
    description = "GNOME Character Map, based on the Unicode Character Database";
    homepage = "https://wiki.gnome.org/Apps/Gucharmap";
    license = licenses.gpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
