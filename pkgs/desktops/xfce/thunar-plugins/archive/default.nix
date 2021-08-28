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
  version = "0.4.0";

  sha256 = "1793zicm00fail4iknliwy2b668j239ndxhc9hy6jarvdyp08h38";

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
  };
}
