{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.1";

  sha256 = "1q13hvaz3ykrbgbbqb1186mhri8r9hkmpaayjwhnkvjm7jfyhbin";

  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel ];
}
