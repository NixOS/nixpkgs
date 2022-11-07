{ stdenv
, fetchFromGitHub
, lib
, pkg-config
, meson
, ninja
, bison
, flex
, gobject-introspection
, gi-docgen
, glib
, gdk-pixbuf
, libxml2
, cairo
, pango
, librsvg
, gtk4
, gitUpdater
, goffice
, makeFontsConf
}:

stdenv.mkDerivation rec {
  pname = "lasem";
  version = "0.7.0";

  outputs = [ "bin" "out" "dev" "man" "devdoc" ];

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "lasem";
    rev = "LASEM_${lib.replaceStrings [ "." ] [ "_"] version}";
    sha256 = "qM0e6xUhYOUSnsemaXhscAhKKHUL0q+cmqvgM15FedU=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    bison
    flex
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    # For the demo.
    gtk4
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    libxml2
    cairo
    pango
  ];

  checkInputs = [
    librsvg
  ];

  mesonFlags = [
    "-Ddocs=enabled"
  ];

  doCheck = true;
  separateDebugInfo = true;

  # Test complains “Fontconfig error: Cannot load default config file”
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ ];
  };

  preCheck = ''
    # Test complains “Fontconfig error: No writable cache directories”
    export HOME="$TMPDIR"
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"

    # Not part of bin, since it depends on GTK.
    moveToOutput "bin/lsm-demo" "$devdoc"
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      inherit goffice;
    };
  };

  meta = with lib; {
    description = "SVG and MathML rendering library";
    homepage = "https://github.com/mjakeman/lasem";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
