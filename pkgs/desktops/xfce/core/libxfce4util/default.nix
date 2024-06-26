{
  lib,
  mkXfceDerivation,
  gobject-introspection,
  vala,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.18.2";

  sha256 = "sha256-JQ6biE1gxtB6+LWxRGfbUhgJhhITGhLr+8BxFW4/8SU=";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  meta = with lib; {
    description = "Extension library for Xfce";
    mainProgram = "xfce4-kiosk-query";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
