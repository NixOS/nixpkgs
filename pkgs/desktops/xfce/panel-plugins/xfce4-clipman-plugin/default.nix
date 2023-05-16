{ lib, mkXfceDerivation, libXtst, libxfce4ui, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
<<<<<<< HEAD
  version = "1.6.4";
  sha256 = "sha256-N/e97C6xWyF1GUg7gMN0Wcw35awypflMmA+Pdg6alEw=";
=======
  version = "1.6.3";
  sha256 = "sha256-tnpQRYLV48NxKsWDjVSmypx6X1bVbx2U5Q8kQaP0AW8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libXtst libxfce4ui xfce4-panel xfconf ];

  meta = with lib; {
    description = "Clipboard manager for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
