{ lib, mkXfceDerivation, libxfce4util, gobject-introspection, vala }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.18.0";

  sha256 = "sha256-8zl2EWV1DRHsH0QUNa13OKvfIVDVOhIO0FCMbU978Js=";

  nativeBuildInputs = [ gobject-introspection vala ];

  buildInputs = [ libxfce4util ];

  meta = with lib; {
    description = "Simple client-server configuration storage and query system for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
