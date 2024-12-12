{
  lib,
  mkXfceDerivation,
  gtk3,
  libnotify,
  librsvg,
  libwnck,
  libxklavier,
  garcon,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-xkb-plugin";
  version = "0.8.3";
  sha256 = "sha256-qWxjULrBpueQS3gxwRg49cQ3ovlQ8iWvYZ6Z/THm+/s=";

  buildInputs = [
    garcon
    gtk3
    libnotify # optional notification support
    librsvg
    libxfce4ui
    libxfce4util
    libxklavier
    libwnck
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Allows you to setup and use multiple keyboard layouts";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
