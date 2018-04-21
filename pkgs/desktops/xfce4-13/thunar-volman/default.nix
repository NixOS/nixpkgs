{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar-volman";
  version = "0.9.0";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "08aqbp3i0z6frj7z3laz9nj641iakrcr7vh2dxb057ky24gj61i7";
}
