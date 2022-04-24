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

  sha256 = "sha256-aEAErm87K2k8TAz2ZtMQEhmzhOeR2hkJjcoBUFn8I50=";

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
