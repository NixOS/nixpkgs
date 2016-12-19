{ stdenv, fetchurl, pkgconfig, intltool, autoreconfHook, gnome2,
  libgtop, libxfce4ui, libxfce4util, xfce4panel, lm_sensors
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname  = "xfce4-hardware-monitor-plugin";
  version = "1.5.0";

  src = fetchurl {
    url = "https://git.xfce.org/panel-plugins/${pname}/snapshot/${name}.tar.bz2";
    sha256 = "0sqvisr8gagpywq9sfyzqw37hxmj54ii89j5s2g8hx8bng5a98z1";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    intltool
  ];

  buildInputs = [
    gnome2.gtkmm2
    gnome2.libgnomecanvas
    gnome2.libgnomecanvasmm
    libgtop
    libxfce4ui
    libxfce4util
    xfce4panel
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
