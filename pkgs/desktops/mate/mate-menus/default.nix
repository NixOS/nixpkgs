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
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "z0DHXH1vCq0dSWmCj8YgJcYiK8aoTwu51urX5FlwUI0=";
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
