{ stdenv, fetchFromGitHub, substituteAll, pkgconfig, gettext, gtk3, glib
, gtk-doc, libarchive, gobject-introspection, libxslt, pngquant
, sqlite, libsoup, attr, acl, docbook_xsl, docbook_xml_dtd_42
, libuuid, json-glib, meson, gperf, ninja, gdk_pixbuf
}:
stdenv.mkDerivation rec {
  name = "appstream-glib-0.7.15";

  outputs = [ "out" "dev" "man" "installedTests" ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "16cqs1s7nqc551sipgaxbbzwap1km0n12s4lcgfbxzzl9bcjbp9m";
  };

  nativeBuildInputs = [
    meson pkgconfig ninja gtk-doc libxslt docbook_xsl docbook_xml_dtd_42 gobject-introspection
  ];
  buildInputs = [
    glib gettext sqlite libsoup
    attr acl libuuid json-glib
    libarchive gperf gdk_pixbuf
  ];
  propagatedBuildInputs = [ gtk3 ];

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
    platforms = platforms.linux;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
