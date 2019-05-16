{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-netload-plugin";
  version = "1.3.1";
  rev = "version-${version}";
  sha256 = "0nm8advafw4jpc9p1qszyfqa56194sz51z216rdh4c6ilcrrpy1h";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];
}
