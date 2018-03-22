{ stdenv, fetchFromGitHub, substituteAll, pkgconfig, gettext, gtk3, glib
, gtk-doc, libarchive, gobjectIntrospection, libxslt, pngquant
, sqlite, libsoup, gcab, attr, acl, docbook_xsl, docbook_xml_dtd_42
, libuuid, json-glib, meson, gperf, ninja
}:
stdenv.mkDerivation rec {
  name = "appstream-glib-0.7.7";

  outputs = [ "out" "dev" "man" "installedTests" ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "127m5ds355i1vfvmn9nd4zqqnqm16jpqcn4p2p2pvn7i4wqxra40";
  };

  nativeBuildInputs = [
    meson pkgconfig ninja gtk-doc libxslt docbook_xsl docbook_xml_dtd_42
  ];
  buildInputs = [
    glib gettext sqlite libsoup
    gcab attr acl libuuid json-glib
    libarchive gobjectIntrospection gperf
  ];
  propagatedBuildInputs = [ gtk3 ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      pngquant= "${pngquant}/bin/pngquant";
    })
  ];

  mesonFlags = [
    "-Drpm=false"
    "-Dstemmer=false"
    "-Ddep11=false"
  ];

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
