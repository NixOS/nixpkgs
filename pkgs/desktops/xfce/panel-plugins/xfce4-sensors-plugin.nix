{ stdenv, fetchurl, pkgconfig, intltool, gtk2, libxfce4ui,
  libxfce4util, xfce4-panel, libnotify, lm_sensors, hddtemp, netcat-gnu
}:

stdenv.mkDerivation rec {
  name = "${pname}-${ver_maj}.${ver_min}";
  pname  = "xfce4-sensors-plugin";
  ver_maj = "1.2";
  ver_min = "6";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${pname}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1h0vpqxcziml3gwrbvd8xvy1mwh9mf2a68dvxsy03rs5pm1ghpi3";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
  ];

  buildInputs = [
    gtk2
    libxfce4ui
    libxfce4util
    xfce4-panel
    libnotify
    lm_sensors
    hddtemp
    netcat-gnu
   ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-pathhddtemp=${hddtemp}/bin/hddtemp"
    "--with-pathnetcat=${netcat-gnu}/bin/netcat"
  ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "A panel plug-in for different sensors using acpi, lm_sensors and hddtemp";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
