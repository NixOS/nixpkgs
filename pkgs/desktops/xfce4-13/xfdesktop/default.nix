{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "1mni8gzgglhwicaw093i2vpk8q2vilmgg5qbr3izbb8ighhr09jl";

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libwnck3
    xfconf
  ];

  meta = {
    description = "Xfce's desktop manager";
  };
}
