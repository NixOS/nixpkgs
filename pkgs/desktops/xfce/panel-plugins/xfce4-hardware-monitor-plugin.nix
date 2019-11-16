{ stdenv, fetchurl, pkgconfig, intltool, autoreconfHook, gnome2, gtkmm2,
  libgtop, libxfce4ui, libxfce4util, xfce4-panel, lm_sensors
}:

stdenv.mkDerivation rec {
  pname  = "xfce4-hardware-monitor-plugin";
  version = "1.6.0";

  src = fetchurl {
    url = "https://git.xfce.org/panel-plugins/${pname}/snapshot/${pname}-${version}.tar.bz2";
    sha256 = "0xg5har11fk1wmdymydxlbk1z8aa39j8k0p4gzw2iqslv3n0zf7b";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    intltool
  ];

  buildInputs = [
    gtkmm2
    gnome2.libgnomecanvas
    gnome2.libgnomecanvasmm
    libgtop
    libxfce4ui
    libxfce4util
    xfce4-panel
    lm_sensors
   ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "Hardware monitor plugin for the XFCE4 panel";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
