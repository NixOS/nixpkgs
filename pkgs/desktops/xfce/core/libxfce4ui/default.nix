{
  mkXfceDerivation,
  lib,
  gobject-introspection,
  perl,
  vala,
  libICE,
  libSM,
  libepoxy,
  libgtop,
  libgudev,
  libstartup_notification,
  xfconf,
  gtk3,
  libxfce4util,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.20.0";

  sha256 = "sha256-M+OapPHQ/WxlkUzHPx+ELstVyGoZanCxCL0N8hDWSN8=";

  nativeBuildInputs = [
    gobject-introspection
    perl
    vala
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

  meta = {
    description = "Widgets library for Xfce";
    mainProgram = "xfce4-about";
    license = with lib.licenses; [
      lgpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ ] ++ lib.teams.xfce.members;
  };
}
