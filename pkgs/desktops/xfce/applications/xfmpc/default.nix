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
  version = "0.3.2";
  sha256 = "sha256-V5YHvhcWv6IUPe8W1VtuPagj3uU3s+ikgu3ZnRF48O4=";

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
    changelog = "https://gitlab.xfce.org/apps/xfmpc/-/blob/xfmpc-${version}/NEWS";
    maintainers = with maintainers; [ doronbehar ] ++ teams.xfce.members;
    mainProgram = "xfmpc";
  };
}
