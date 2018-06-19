{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, libcanberra-gtk3, libgtop, gnome2, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "marco-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1fn0yfqjp44gr4kly96qjsd73x06z1xyw6bpyhh09kdqwd80rgiy";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    libcanberra-gtk3
    libgtop
    gnome2.startup_notification
    gnome3.gtk
    gnome3.zenity
  ];
  
  meta = with stdenv.lib; {
    description = "MATE default window manager";
    homepage = https://github.com/mate-desktop/marco;
    license = [ licenses.gpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
