{ lib, stdenv, fetchurl, pkg-config, gettext, glib, gobject-introspection, python3, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-menus";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17zc9fn14jykhn30z8iwlw0qwk32ivj6gxgww3xrqvqk0da5yaas";
  };

  nativeBuildInputs = [ pkg-config gettext gobject-introspection ];

  buildInputs = [ glib python3 ];

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Menu system for MATE";
    homepage = "https://github.com/mate-desktop/mate-menus";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
