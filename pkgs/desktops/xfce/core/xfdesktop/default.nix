{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf, libnotify, garcon, thunar }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.16.0";

  sha256 = "1znbccr25wvizmzzgdcf719y3qc9gqdi1g4rasgrmi95427lvwn3";

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libwnck3
    xfconf
    libnotify
    garcon
    thunar
  ];

  meta = {
    description = "Xfce's desktop manager";
  };
}
