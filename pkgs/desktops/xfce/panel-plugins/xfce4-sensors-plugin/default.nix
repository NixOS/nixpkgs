{ lib, stdenv, fetchurl, pkg-config, intltool, gtk3, libxfce4ui,
  libxfce4util, xfce4-panel, libnotify, lm_sensors, hddtemp, netcat-gnu, xfce
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname  = "xfce4-sensors-plugin";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-N9DcVp5zXkgqGFRcJOsc4CKdaRDjpNTB3uBoCZkjS+I=";
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
