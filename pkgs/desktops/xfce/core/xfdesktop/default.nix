{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf, libnotify, garcon, thunar }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.14.2";

  sha256 = "04fhm1pf9290sy3ymrmnfnm2x6fq5ldzvj5bjd9kz6zkx0nsq1za";

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
