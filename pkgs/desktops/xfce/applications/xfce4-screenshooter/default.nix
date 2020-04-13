{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel, glib-networking }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.5";

  sha256 = "1h14sywvk9l06p3z1cpb79911j8w2wqbk03ldknjkia2rfymjk06";

  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel glib-networking ];

  meta = {
    description = "Screenshot utility for the Xfce desktop";
  };
}
