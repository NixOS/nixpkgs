{ mkXfceDerivation, gtk3, glib, libexif
, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "ristretto";
  version = "0.11.0";

  sha256 = "07np4n6kg6lpd7acrb4aga3l6502c8lhjzf867b38n90cx1nh5gf";

  buildInputs = [ glib gtk3 libexif libxfce4ui libxfce4util xfconf ];

  meta = {
    description = "A fast and lightweight picture-viewer for the Xfce desktop environment";
  };
}
