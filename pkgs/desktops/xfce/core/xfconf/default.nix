{
  lib,
  mkXfceDerivation,
  gobject-introspection,
  perl,
  vala,
  libxfce4util,
  glib,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.20.0";

  sha256 = "sha256-U+Sk7ubBr1ZD1GLQXlxrx0NQdhV/WpVBbnLcc94Tjcw=";

  nativeBuildInputs = [
    gobject-introspection
    perl
    vala
  ];

  buildInputs = [ libxfce4util ];

  propagatedBuildInputs = [ glib ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    mainProgram = "xfconf-query";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
