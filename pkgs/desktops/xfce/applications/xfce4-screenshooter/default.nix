{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel, glib-networking }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.9";
  odd-unstable = false;

  sha256 = "sha256-QOYJl+bxRk0+spgtGADPgkw2lPLfQOwTZQuZNHWq39c=";

  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel glib-networking ];

  meta = {
    description = "Screenshot utility for the Xfce desktop";
  };
}
