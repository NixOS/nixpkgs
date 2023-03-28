{ lib
, mkXfceDerivation
, gtk3
, thunar
, exo
, libxfce4util
, intltool
, gettext
}:

mkXfceDerivation {
  category = "thunar-plugins";
  pname  = "thunar-archive-plugin";
  version = "0.5.0";
  odd-unstable = false;

  sha256 = "sha256-3a42chfv4UQYkvWKCX0FShAcEwt9icJARTHGEgs6/8M=";

  nativeBuildInputs = [
    intltool
    gettext
  ];

  buildInputs = [
    thunar
    exo
    gtk3
    libxfce4util
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Thunar plugin providing file context menus for archives";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
