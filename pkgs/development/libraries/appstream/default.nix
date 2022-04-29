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
, libxmlb
, libyaml
, gobject-introspection
, pcre
, itstool
, gperf
, vala
, curl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "appstream";
  version = "0.15.2";
  # When bumping this package, please also check whether
  # fix-build-for-qt-olderthan-514.patch still applies by
  # building libsForQt512.appstream-qt.

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${version}";
    sha256 = "sha256-/JZ49wjtcInbGUOVVjevVSrLCHcA60FMT165rhfb78Q=";
  };

  patches = [
    # Fix hardcoded paths
    (substituteAll {
      src = ./fix-paths.patch;
      libstemmer_includedir = "${lib.getDev libstemmer}/include";
    })

    # Allow installing installed tests to a separate output.
    ./installed-tests-path.patch
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
    libxmlb
    libyaml
    gperf
    curl
  ];

  mesonFlags = [
    "-Dapidocs=false"
    "-Ddocs=false"
    "-Dvapi=true"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
  ];

  passthru = {
    tests = {
      installed-tests = nixosTests.installed-tests.appstream;
    };
  };

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
