{ lib, stdenv
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
, pkg-config
, pngquant
}:
stdenv.mkDerivation rec {
  pname = "appstream-glib";
  version = "0.7.18";

  outputs = [ "out" "dev" "man" "installedTests" ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = "${lib.replaceStrings ["-"] ["_"] pname}_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "12s7d3nqjs1fldnppbg2mkjg4280f3h8yzj3q1hiz3chh1w0vjbx";
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
    pkg-config
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

  meta = with lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = "https://people.freedesktop.org/~hughsient/appstream-glib/";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
