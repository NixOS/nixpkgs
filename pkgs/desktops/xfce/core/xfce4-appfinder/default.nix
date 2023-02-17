{ lib, mkXfceDerivation, exo, garcon, gtk3, libxfce4util, libxfce4ui, xfconf }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfce4-appfinder";
  version = "4.18.0";

  sha256 = "sha256-/VYZpWk08OQPZ/DQ5SqSL4F4KDdh+IieQBDOZUxZvtw=";

  nativeBuildInputs = [ exo ];
  buildInputs = [ garcon gtk3 libxfce4ui libxfce4util xfconf ];

  meta = with lib; {
    description = "Appfinder for the Xfce4 Desktop Environment";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
