{ stdenv, fetchurl, pkgconfig, intltool, itstool, glib, libwnck3, librsvg, libxml2, dconf, gtk3, mate, hicolor-icon-theme, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-panel";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sm0fniywcxg8rbakhhc37bamwq1x3jqqyaqcvqwxvm6jg1hc97y";
  };

  nativeBuildInputs = [
    gobject-introspection
    intltool
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

  meta = with stdenv.lib; {
    description = "The MATE panel";
    homepage = https://github.com/mate-desktop/mate-panel;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
