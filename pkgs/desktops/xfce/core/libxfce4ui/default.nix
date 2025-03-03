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
  version = "4.20.0";

  sha256 = "sha256-M+OapPHQ/WxlkUzHPx+ELstVyGoZanCxCL0N8hDWSN8=";

  nativeBuildInputs =
    [
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
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
