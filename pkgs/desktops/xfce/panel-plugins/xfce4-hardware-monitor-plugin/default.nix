{ lib, stdenv, fetchurl, pkg-config, intltool, autoreconfHook, gnome2, gtkmm2,
  libgtop, libxfce4ui, libxfce4util, xfce4-panel, lm_sensors, xfce
}:

stdenv.mkDerivation rec {
  pname  = "xfce4-hardware-monitor-plugin";
  version = "1.6.0";

  src = fetchurl {
    url = "https://git.xfce.org/archive/${pname}/snapshot/${pname}-${version}.tar.gz";
    sha256 = "sha256-aLpNY+qUhmobGb8OkbjtJxQMDO9xSlvurVjNLgOpZ4Y=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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

  meta = with lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/xfce4-hardware-monitor-plugin";
    description = "Hardware monitor plugin for the XFCE4 panel";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    broken = true; # unmaintained plugin; no longer compatible with xfce 4.16
    maintainers = [ maintainers.romildo ];
  };
}
