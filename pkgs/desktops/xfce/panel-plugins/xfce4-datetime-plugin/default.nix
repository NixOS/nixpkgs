{
  mkXfceDerivation,
  lib,
  intltool,
  libxfce4ui,
  xfce4-panel,
  gettext,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-datetime-plugin";
  version = "0.8.3";

  rev-prefix = "xfce4-datetime-plugin-";
  sha256 = "sha256-dpN5ZN7VjgO1GQ6v8NXuBKACyIwIosaiVGtmLEb6auI=";

  nativeBuildInputs = [
    gettext
    intltool
  ];

  buildInputs = [
    libxfce4ui
    xfce4-panel
  ];

  meta = with lib; {
    description = "Shows the date and time in the panel, and a calendar appears when you left-click on it";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
