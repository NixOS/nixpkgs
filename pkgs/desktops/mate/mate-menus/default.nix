{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, gobject-introspection
, python3
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-menus";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "RY1ZmuW2UMfSF0D5/pVMSoOL5F7WKrQOIOMG+vXdHYw=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
  ];

  buildInputs = [
    glib
    python3
  ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Menu system for MATE";
    homepage = "https://github.com/mate-desktop/mate-menus";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
