{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel, glib-networking }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.9";
  odd-unstable = false;

  sha256 = "1myzm9sk968bcl9yqh6zyaa3ck42rw01hbcqn8z4sipiwsbhkrj0";

  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel glib-networking ];

  meta = {
    description = "Screenshot utility for the Xfce desktop";
  };
}
