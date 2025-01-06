{
  mkXfceDerivation,
  lib,
  gobject-introspection,
  vala,
  glib,
}:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.20.0";

  sha256 = "sha256-0qbJSCXHsVz3XILHICFhciyz92LgMZiR7XFLAESHRGQ=";

  nativeBuildInputs = [
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    glib
  ];

  meta = {
    description = "Extension library for Xfce";
    mainProgram = "xfce4-kiosk-query";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ] ++ lib.teams.xfce.members;
  };
}
