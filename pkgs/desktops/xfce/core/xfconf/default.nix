{
  lib,
  mkXfceDerivation,
  libxfce4util,
  gobject-introspection,
  vala,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.18.3";

  sha256 = "sha256-Iu/LHyk/lOvu8uJuJRDxIkabiX0vZB4H99vVKRiugVo=";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    mainProgram = "xfconf-query";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
