{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  intltool,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  libnotify,
  lm_sensors,
  hddtemp,
  netcat-gnu,
  libXNVCtrl,
  nvidiaSupport ? lib.meta.availableOn stdenv.hostPlatform libXNVCtrl,
  gitUpdater,
}:

let
  category = "panel-plugins";
in

stdenv.mkDerivation rec {
  pname = "xfce4-sensors-plugin";
  version = "1.4.4";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-bBYFpzjl30DghNCKyT+WLNRFCTOW3h6b+tx6tFiMNrY=";
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
  ] ++ lib.optionals nvidiaSupport [ libXNVCtrl ];

  enableParallelBuilding = true;

  configureFlags =
    [
      "--with-pathhddtemp=${hddtemp}/bin/hddtemp"
      "--with-pathnetcat=${netcat-gnu}/bin/netcat"
    ]
    ++ lib.optionals nvidiaSupport [
      # Have to be explicitly enabled since this tries to figure out the default
      # based on the existence of a hardcoded `/usr/include/NVCtrl` path.
      "--enable-xnvctrl"
    ];

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.xfce.org/panel-plugins/${pname}";
    rev-prefix = "${pname}-";
  };

  meta = with lib; {
    homepage = "https://docs.xfce.org/panel-plugins/xfce4-sensors-plugin";
    description = "Panel plug-in for different sensors using acpi, lm_sensors and hddtemp";
    mainProgram = "xfce4-sensors";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
