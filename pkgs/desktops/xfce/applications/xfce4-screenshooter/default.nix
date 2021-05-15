{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel, glib-networking }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.8";
  odd-unstable = false;

  sha256 = "0pbzjcaxm8gk0s75s99kvzygmih4yghp7ngf2mxymjiywcxqr40d";

  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel glib-networking ];

  meta = {
    description = "Screenshot utility for the Xfce desktop";
  };
}
