{ lib, stdenv, fetchurl, pkg-config, intltool, gtk3, libxfce4ui,
  libxfce4util, xfce4-panel, libnotify, lm_sensors, hddtemp, netcat-gnu, xfce
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-sensors-plugin";
  version = "1.3.95";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "0v44qwrwb95jrlsni1gdlc0zhymlm62w42zs3jbr5mcdc7j4mil3";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    gtk3
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

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.archiveLister category pname;
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-sensors-plugin";
    description = "A panel plug-in for different sensors using acpi, lm_sensors and hddtemp";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
