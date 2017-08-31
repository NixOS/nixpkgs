{ stdenv, fetchurl, pkgconfig, intltool, itstool, glib, dbus_glib, libwnck3, librsvg, libxml2, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-panel-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "4";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1n565ff1n7jrfx223i3cl3m69wjda506nvbn8gra7m1jwdfzpbw1";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    dbus_glib
    libwnck3
    librsvg
    libxml2
    gnome3.gtk
    gnome3.dconf
    mate.libmateweather
    mate.mate-desktop
    mate.mate-menus
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
