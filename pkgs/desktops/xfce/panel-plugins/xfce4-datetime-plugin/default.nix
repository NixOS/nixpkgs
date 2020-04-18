{ mkXfceDerivation
, stdenv
, intltool
, libxfce4ui
, xfce4-panel
, gtk3
, gettext
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-datetime-plugin";
  version = "0.8.0";

  rev-prefix = "datetime-";
  sha256 = "12drh7y70d70r93lpv43fkj5cbyl0vciz4a41nxrknrfbhxrvyah";

  nativeBuildInputs = [
    gettext
    intltool
  ];

  buildInputs = [
    gtk3
    libxfce4ui
    xfce4-panel
  ];

  meta = with stdenv.lib; {
    description = "Shows the date and time in the panel, and a calendar appears when you left-click on it";
    maintainers = [ maintainers.AndersonTorres ];
  };
}
