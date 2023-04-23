{ lib, mkXfceDerivation, libXtst, libxfce4ui, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.3";
  sha256 = "sha256-tnpQRYLV48NxKsWDjVSmypx6X1bVbx2U5Q8kQaP0AW8=";

  buildInputs = [ libXtst libxfce4ui xfce4-panel xfconf ];

  meta = with lib; {
    description = "Clipboard manager for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
