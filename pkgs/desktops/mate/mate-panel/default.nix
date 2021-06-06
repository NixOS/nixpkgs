{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, glib, libwnck3, librsvg, libxml2, dconf, gtk3, mate, hicolor-icon-theme, gobject-introspection, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-panel";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sj851h71nq4ssrsd4k5b0vayxmspl5x3rhf488b2xpcj81vmi9h";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    itstool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    libwnck3
    librsvg
    libxml2
    gtk3
    dconf
    mate.libmateweather
    mate.mate-desktop
    mate.mate-menus
    hicolor-icon-theme
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "The MATE panel";
    homepage = "https://github.com/mate-desktop/mate-panel";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
