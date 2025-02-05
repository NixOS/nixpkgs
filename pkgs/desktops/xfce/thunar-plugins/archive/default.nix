{
  lib,
  mkXfceDerivation,
  gtk3,
  thunar,
  exo,
  libxfce4util,
  gettext,
}:

mkXfceDerivation {
  category = "thunar-plugins";
  pname = "thunar-archive-plugin";
  version = "0.5.3";
  odd-unstable = false;

  sha256 = "sha256-9EjEQml/Xdj/jCtC4ZuGdmpeNnOqUWJOqoVzLuxzG6s=";

  nativeBuildInputs = [
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
