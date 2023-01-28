{ lib, mkXfceDerivation, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "libxfce4util";
  version = "4.18.0";

  sha256 = "sha256-m4O/vTFqzkF6rzyGVw8xdwcX7S/SyOSJo8aCZjniXAw=";

  nativeBuildInputs = [ gobject-introspection vala ];

  meta = with lib; {
    description = "Extension library for Xfce";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
