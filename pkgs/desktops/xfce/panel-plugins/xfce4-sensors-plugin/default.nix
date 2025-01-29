{
  stdenv,
  lib,
  fetchurl,
  gettext,
  pkg-config,
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
  version = "1.4.5";

  src = fetchurl {
    url = "mirror://xfce/src/${category}/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-9p/febf3bSqBckgoEkpvznaAOpEipMgt6PPfo++7F5o=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
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
