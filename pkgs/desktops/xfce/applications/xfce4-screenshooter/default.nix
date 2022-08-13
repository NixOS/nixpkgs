{ lib
, mkXfceDerivation
, exo
, glib-networking
, gtk3
, libsoup
, libxfce4ui
, libxfce4util
, xfce4-panel
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.10";
  odd-unstable = false;

  sha256 = "sha256-i3QdQij58JYv3fWdESUeTV0IW3A8RVGNtmuxUc6FUMg=";

  buildInputs = [
    exo
    glib-networking
    gtk3
    libsoup
    libxfce4ui
    libxfce4util
    xfce4-panel
  ];

  meta = with lib; {
    description = "Screenshot utility for the Xfce desktop";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
