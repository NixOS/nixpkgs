{ lib
, mkXfceDerivation
, gtk3
, libxfce4ui
, pcre
, libxfce4util
, xfce4-panel
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-verve-plugin";
  version = "2.0.1";
  rev-prefix = "";
  sha256 = "sha256-YwUOSTZMoHsWWmi/ajQv/fX8a0IJoc3re3laVEmnX/M=";

  buildInputs = [ gtk3 libxfce4ui pcre libxfce4util xfce4-panel ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A command-line plugin";
    maintainers = with maintainers; [ ];
  };
}
