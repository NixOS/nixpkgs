{ mkXfceDerivation, gtk3, libXtst, libxfce4ui, libxfce4util, xfce4-panel, xfconf, exo }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.4.2";
  rev = version;
  sha256 = "1c2h1cs7pycf1rhpirmvb0l0dfvlacb7xgm31q9rxmhihnycd2na";

  buildInputs = [ exo gtk3 libXtst libxfce4ui libxfce4util xfce4-panel xfconf ];
}
