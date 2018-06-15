{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, libcanberra-gtk3, libgtop, gnome2, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "marco-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1qnx47aibvl00qaf1jik457cwncxb71pf5pd1m3gdg7ky61ljkm4";
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
