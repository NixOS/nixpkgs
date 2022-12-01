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
  version = "1.9.11";
  odd-unstable = false;

  sha256 = "sha256-sW0SEXypCcly7MlO9lnxHTkYwIiRt+gOME5UQ++Y3JQ=";

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
