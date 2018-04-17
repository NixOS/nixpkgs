{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.13.1";

  sha256 = "0idc8j44apflvdasnvj7ld0fa8mxlwpndfqzbh97w54s8972gf6g";

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
