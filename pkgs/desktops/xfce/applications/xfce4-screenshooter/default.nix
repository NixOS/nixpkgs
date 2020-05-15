{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel, glib-networking }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.7";
  odd-unstable = false;

  sha256 = "14vbd7iigaw57hl47rnixk873c20q5clqynzkm9zzpqc568dxixd";

  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel glib-networking ];

  meta = {
    description = "Screenshot utility for the Xfce desktop";
  };
}
