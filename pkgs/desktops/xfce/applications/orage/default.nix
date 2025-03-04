{
  lib,
  mkXfceDerivation,
  glib,
  gtk3,
  libical,
  libnotify,
  libxfce4ui,
  libxfce4util,
  tzdata,
}:

mkXfceDerivation {
  category = "apps";
  pname = "orage";
  version = "4.20.0";

  sha256 = "sha256-VaabhMRgH/q9HiFXBPQ90HbMLW21BXTvZtxd8bhYYnw=";

  buildInputs = [
    glib
    gtk3
    libical
    libnotify
    libxfce4ui
    libxfce4util
  ];

  postPatch = ''
    substituteInPlace src/parameters.c        --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace src/tz_zoneinfo_read.c  --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  meta = with lib; {
    description = "Simple calendar application for Xfce";
    mainProgram = "orage";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
