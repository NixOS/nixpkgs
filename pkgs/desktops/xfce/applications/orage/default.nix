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
  version = "4.20.1";

  sha256 = "sha256-WdvqsgHfhJ2sk4vQ75m1zmWjefJBJdDKH8E0GA4fCNg=";

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
    teams = [ teams.xfce ];
  };
}
