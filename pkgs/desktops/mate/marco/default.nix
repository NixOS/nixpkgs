{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, libcanberra_gtk3, libgtop, gnome2, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "marco-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0lwbp9wyd66hl5d7g272l8g3k1pb9s4s2p9fb04750a58w87d8k5";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    libcanberra_gtk3
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
