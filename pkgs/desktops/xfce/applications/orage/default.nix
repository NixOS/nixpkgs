{
  lib,
  mkXfceDerivation,
  gtk3,
  libical,
  libnotify,
  libxfce4ui,
  popt,
  tzdata,
}:

mkXfceDerivation {
  category = "apps";
  pname = "orage";
  version = "4.18.0";

  sha256 = "sha256-vL9zexPbQKPqIzK5UqUIxkE9I7hEupkDOJehMgj2Leo=";

  buildInputs = [
    gtk3
    libical
    libnotify
    libxfce4ui
    popt
  ];

  postPatch = ''
    substituteInPlace src/parameters.c        --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace src/tz_zoneinfo_read.c  --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  meta = with lib; {
    description = "Simple calendar application for Xfce";
    mainProgram = "orage";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
