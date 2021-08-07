{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "thunar-volman";
  version = "4.16.0";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "sha256-A9APQ5FLshb+MXQErCExegax6hqbHnlfI2hgtnWfVgA=";

  odd-unstable = false;

  meta = {
    description = "Thunar extension for automatic management of removable drives and media";
  };
}
