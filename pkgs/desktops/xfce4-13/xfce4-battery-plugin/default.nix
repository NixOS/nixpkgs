{ mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-battery-plugin";
  version = "1.1.0";
  rev = version;
  sha256 = "0mz0lj3wjrsj9n4wcqrvv08430g38nkjbdimxdy8316n6bqgngfn";

  buildInputs = [ gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];
}
