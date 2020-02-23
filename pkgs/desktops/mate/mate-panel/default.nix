{ stdenv, fetchurl, pkgconfig, gettext, itstool, glib, libwnck3, librsvg, libxml2, dconf, gtk3, mate, hicolor-icon-theme, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-panel";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1hrh10pqk8mva1ix2nmsp3cbbn81cgqy0b9lqhsl0b5p0s40i7in";
  };

  nativeBuildInputs = [
    gobject-introspection
    gettext
    itstool
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "The MATE panel";
    homepage = "https://github.com/mate-desktop/mate-panel";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
