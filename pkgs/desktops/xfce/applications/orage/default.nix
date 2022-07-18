{ lib
, mkXfceDerivation
, dbus-glib
, gtk3
, libical
, libnotify
, libxfce4ui
, popt
, tzdata
, xfce4-panel
, withPanelPlugin ? true
}:

mkXfceDerivation {
  category = "apps";
  pname = "orage";
  version = "4.16.0";
  odd-unstable = false;
  sha256 = "sha256-Q2vTjfhbhG7TrkGeU5oVBB+UvrV5QFtl372wgHU4cxw=";

  buildInputs = [
    dbus-glib
    gtk3
    libical
    libnotify
    libxfce4ui
    popt
  ]
  ++ lib.optionals withPanelPlugin [
    xfce4-panel
  ];

  postPatch = ''
    substituteInPlace src/parameters.c        --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace src/tz_zoneinfo_read.c  --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace tz_convert/tz_convert.c --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  postConfigure = ''
    # ensure pkgs.libical is used instead of one included in the orage sources
    rm -rf libical
  '';

  meta = with lib; {
    description = "Simple calendar application for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
