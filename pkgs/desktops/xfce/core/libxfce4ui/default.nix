{
  stdenv,
  mkXfceDerivation,
  lib,
  perl,
  libICE,
  libSM,
  libepoxy,
  libgtop,
  libgudev,
  libstartup_notification,
  xfconf,
  gtk3,
  libxfce4util,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  vala,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.20.2";

  sha256 = "sha256-NsTrJ2271v8vMMyiEef+4Rs0KBOkSkKPjfoJdgQU0ds=";

  nativeBuildInputs = [
    perl
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
    vala # vala bindings require GObject introspection
  ];

  buildInputs = [
    libICE
    libSM
    libepoxy
    libgtop
    libgudev
    libstartup_notification
    xfconf
  ];

  propagatedBuildInputs = [
    gtk3
    libxfce4util
  ];

  configureFlags = [
    "--with-vendor-info=NixOS"
  ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    mainProgram = "xfce4-about";
    license = with licenses; [
      lgpl2Plus
      lgpl21Plus
    ];
    teams = [ teams.xfce ];
  };
}
