{ lib, mkXfceDerivation, libxfce4util, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.18.1";

  sha256 = "sha256-HS+FzzTTAH8lzBBai3ESdnuvvvZW/vAVSmGe57mwcoo=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
