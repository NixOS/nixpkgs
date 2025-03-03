{ lib
, mkXfceDerivation
, libxfce4util
, gobject-introspection
, vala
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.20.0";

  sha256 = "sha256-U+Sk7ubBr1ZD1GLQXlxrx0NQdhV/WpVBbnLcc94Tjcw=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    mainProgram = "xfconf-query";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
