{ stdenv, fetchurl, pkgconfig, gettext, itstool, libxml2, libcanberra-gtk3, libgtop, libstartup_notification, gnome3, gtk3, mate-settings-daemon, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "marco";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "109b41pjrc1b4slw6sx1lakdhrc46x829vczzk4bz3j15kcszg54";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
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
    mate-settings-daemon
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = [ licenses.gpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
