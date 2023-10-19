{ lib, mkXfceDerivation, libxfce4util, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.18.2";

  sha256 = "sha256-FVNkcwOS4feMocx3vYhuWNs1EkXDrM1FaKkMhIOuPHI=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
