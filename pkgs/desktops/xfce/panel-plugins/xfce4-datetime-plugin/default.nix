{ mkXfceDerivation
, lib
, intltool
, libxfce4ui
, xfce4-panel
, gettext
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-datetime-plugin";
  version = "0.8.1";

  rev-prefix = "xfce4-datetime-plugin-";
  sha256 = "sha256-qmZit7cCGnVTzdzPTiAiruBWlMLWzZEXJtFqAesaARo=";

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
    maintainers = [ ];
  };
}
