{
  lib,
  mkXfceDerivation,
  vala,
  libxfce4util,
  libxfce4ui,
  gtk3,
  glib,
  libmpd,
}:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfmpc";
  # Last release is too old
  version = "0.3.1-2024-05-29";
  rev = "cf40dffec6e9b80abb1f1aa6d7dceef4790173dc";
  sha256 = "sha256-moCWSLGBJuWM4/lRJi6D3w38iJeCntLo3Vl/eVfu7lw=";

  nativeBuildInputs = [
    vala
    libxfce4util
    # Needed both here and in buildInputs for cross compilation to work
    libxfce4ui
  ];
  buildInputs = [
    gtk3
    glib
    libxfce4ui
    libmpd
  ];

  meta = with lib; {
    description = "MPD client written in GTK";
    homepage = "https://docs.xfce.org/apps/xfmpc/start";
    changelog = "https://gitlab.xfce.org/apps/xfmpc/-/blob/${rev}/NEWS";
    maintainers = with maintainers; [ doronbehar ] ++ teams.xfce.members;
    mainProgram = "xfmpc";
  };
}
