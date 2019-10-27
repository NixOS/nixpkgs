{ stdenv
, fetchFromGitHub
, substituteAll
, docbook_xml_dtd_42
, docbook_xsl
, fontconfig
, freetype
, gdk-pixbuf
, gettext
, glib
, gobject-introspection
, gperf
, gtk-doc
, gtk3
, json-glib
, libarchive
, libsoup
, libuuid
, libxslt
, meson
, ninja
, pkgconfig
, pngquant
}:
stdenv.mkDerivation rec {
  name = "appstream-glib-0.7.15";

  outputs = [ "out" "dev" "man" "installedTests" ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings [ "." "-" ] [ "_" "_" ] name;
    sha256 = "16cqs1s7nqc551sipgaxbbzwap1km0n12s4lcgfbxzzl9bcjbp9m";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_42
    docbook_xsl
    gettext
    gobject-introspection
    gperf
    gtk-doc
    libxslt
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    json-glib
    libarchive
    libsoup
    libuuid
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      pngquant = "${pngquant}/bin/pngquant";
    })
  ];

  mesonFlags = [
    "-Drpm=false"
    "-Dstemmer=false"
    "-Ddep11=false"
  ];

  doCheck = false; # fails at least 1 test

  postInstall = ''
    moveToOutput "share/installed-tests" "$installedTests"
  '';

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = https://people.freedesktop.org/~hughsient/appstream-glib/;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
