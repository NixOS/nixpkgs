{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, gtk3, libtool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12pnj7y01k1fhfhswxmf6q9yyb0772am5anm338hzfhjp0lcxlbn";
  };

  buildInputs = [
     glib
     itstool
     libxml2
     libcanberra-gtk3
     gtk3
     gnome3.libgnome-keyring
     libnotify
     dbus-glib
     upower
     mate.mate-panel
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    wrapGAppsHook
  ];

  configureFlags = [ "--enable-applets" ];

  meta = with stdenv.lib; {
    description = "The MATE Power Manager";
    homepage = https://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
