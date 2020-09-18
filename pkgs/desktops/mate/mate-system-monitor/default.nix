{ stdenv, fetchurl, pkgconfig, gettext, itstool, gtkmm3, libxml2, libgtop, libwnck3, librsvg, polkit, systemd, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-system-monitor";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1i2r4lw6xsk972yp15g5hm8p8xx9pp6jmcvvzbdq80xyx3x898qz";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    libwnck3
    librsvg
    polkit
    systemd
  ];

  configureFlags = [ "--enable-systemd" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "System monitor for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
