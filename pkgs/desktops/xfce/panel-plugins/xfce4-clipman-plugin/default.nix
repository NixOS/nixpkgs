{ mkXfceDerivation, gtk3, libXtst, libxfce4ui, libxfce4util, xfce4-panel, xfconf, exo }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.1";
  sha256 = "03akijvry1n1fkziyvxwcksl4vy4lmnpgd5izjs8jai5sndhsszl";

  buildInputs = [ exo gtk3 libXtst libxfce4ui libxfce4util xfce4-panel xfconf ];

  meta = {
    description = "Clipboard manager for Xfce panel";
  };
}
