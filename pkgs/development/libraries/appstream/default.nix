{ lib
, stdenv
, substituteAll
, fetchFromGitHub
, meson
, mesonEmulatorHook
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
  version = "0.15.5";

  outputs = [ "out" "dev" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ximion";
    repo = "appstream";
    rev = "v${version}";
    sha256 = "sha256-KVZCtu1w5FMgXZMiSW55rbrI6W/A9zWWKKvACtk/jjk=";
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

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
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
    gperf
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    libstemmer
    pcre
    glib
    xapian
    libxml2
    libxmlb
    libyaml
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
    longDescription = ''
      AppStream is a cross-distro effort for building Software-Center applications
      and enhancing metadata provided by software components.  It provides
      specifications for meta-information which is shipped by upstream projects and
      can be consumed by other software.
    '';
    homepage = "https://www.freedesktop.org/wiki/Distributions/AppStream/";
    license = licenses.lgpl21Plus;
    mainProgram = "appstreamcli";
    platforms = platforms.unix;
  };
}
