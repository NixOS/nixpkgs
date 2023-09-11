{ lib, mkXfceDerivation, libXtst, libxfce4ui, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.4";
  sha256 = "sha256-N/e97C6xWyF1GUg7gMN0Wcw35awypflMmA+Pdg6alEw=";

  buildInputs = [ libXtst libxfce4ui xfce4-panel xfconf ];

  meta = with lib; {
    description = "Clipboard manager for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
