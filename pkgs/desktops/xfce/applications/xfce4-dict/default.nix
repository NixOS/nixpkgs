{
  lib,
  mkXfceDerivation,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-dict";
  version = "0.8.6";

  sha256 = "sha256-a7St9iH+jzwq/llrMJkuqwgQrDFEjqebs/N6Lxa3dkI=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  meta = with lib; {
    description = "A Dictionary Client for the Xfce desktop environment";
    mainProgram = "xfce4-dict";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
