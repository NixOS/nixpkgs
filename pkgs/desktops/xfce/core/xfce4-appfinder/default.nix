{ mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.16.1";

  sha256 = "sha256-Xr8iiCDQYmxiLR2+TeuJggV1dLM/U4b7u7kpvFWT+uQ=";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];

  meta = {
    description = "Appfinder for the Xfce4 Desktop Environment";
  };
}
