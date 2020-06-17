{ stdenv, fetchurl, pkgconfig, intltool, autoreconfHook, gnome2, gtkmm2,
  libgtop, libxfce4ui, libxfce4util, xfce4-panel, lm_sensors, xfce
}:

stdenv.mkDerivation rec {
  pname  = "xfce4-hardware-monitor-plugin";
  version = "1.6.0";

  src = fetchurl {
    url = "https://git.xfce.org/archive/${pname}/snapshot/${pname}-${version}.tar.gz";
    sha256 = "11k7m41jxkaqmpp5njkixw60q517xnw923mz34dnm1llx9ilvfk8";
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

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/xfce4-hardware-monitor-plugin";
    description = "Hardware monitor plugin for the XFCE4 panel";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
