{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtkmm3, libxml2, libgtop, libwnck3, librsvg, systemd, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-system-monitor-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0yh1sh5snd7ivchh6l9rbn1s7ia4j5ihhzhqkyjnhr8ln59dvcbm";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    libwnck3
    librsvg
    systemd
  ];

  configureFlags = [ "--enable-systemd" ];

  meta = with stdenv.lib; {
    description = "System monitor for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
