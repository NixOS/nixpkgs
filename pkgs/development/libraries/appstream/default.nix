{ lib
, stdenv
, substituteAll
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gettext
, xmlto
, docbook-xsl-nons
, docbook_xml_dtd_45
, libxslt
, libstemmer
, glib
, xapian
, libxml2
, libyaml
, gobject-introspection
, pcre
, itstool
, gperf
, vala
, lmdb
, curl
}:

stdenv.mkDerivation rec {
  pname = "appstream";
  version = "0.14.4";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${version}";
    sha256 = "sha256-DJXCw50f+8c58bJw6xx0ECfkc9/KcWaeA+ne2zmTyhg=";
  };

  patches = [
    # Fix hardcoded paths
    (substituteAll {
      src = ./fix-paths.patch;
      libstemmer_includedir = "${lib.getDev libstemmer}/include";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxslt
    xmlto
    docbook-xsl-nons
    docbook_xml_dtd_45
    gobject-introspection
    itstool
    vala
  ];

  buildInputs = [
    libstemmer
    pcre
    glib
    xapian
    libxml2
    libyaml
    gperf
    lmdb
    curl
  ];

  mesonFlags = [
    "-Dapidocs=false"
    "-Ddocs=false"
    "-Dvapi=true"
  ];

  meta = with lib; {
    description = "Software metadata handling library";
    homepage = "https://www.freedesktop.org/wiki/Distributions/AppStream/";
    longDescription = ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
 };
}
