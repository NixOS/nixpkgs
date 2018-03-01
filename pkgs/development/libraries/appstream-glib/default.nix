{ stdenv, fetchFromGitHub, substituteAll, pkgconfig, gettext, gtk3, glib
, gtk-doc, libarchive, gobjectIntrospection, libxslt, pngquant
, sqlite, libsoup, gcab, attr, acl, docbook_xsl, docbook_xml_dtd_42
, libuuid, json-glib, meson, gperf, ninja
}:
stdenv.mkDerivation rec {
  name = "appstream-glib-0.7.6";

  outputs = [ "out" "dev" "man" ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "1nzm6w9n7fb2m06w88gwszaqf74bnip87ay0ca59wajq6y4mpfgv";
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

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = https://people.freedesktop.org/~hughsient/appstream-glib/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
