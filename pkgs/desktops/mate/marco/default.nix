{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, libcanberra-gtk3, libgtop, libstartup_notification, gnome3, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "marco";
  version = "1.22.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0sc7x14229yj22ka1vlzbaqndwcgh6idypjmm9rydkj4n968jwry";
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
    libstartup_notification
    gtk3
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
