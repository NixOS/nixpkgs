{ stdenv, fetchurl, pkgconfig, intltool, itstool, gtkmm3, libxml2, libgtop, libwnck3, librsvg, systemd, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-system-monitor-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1xhz7d9045xfh431rn27kh1sd1clbzkfrw1zkjgfnpad6v3aaaks";
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

  configureFlags = "--enable-systemd";

  meta = with stdenv.lib; {
    description = "System monitor for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
