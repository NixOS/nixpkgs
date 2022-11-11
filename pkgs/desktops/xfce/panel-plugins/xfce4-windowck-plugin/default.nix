{ lib
, mkXfceDerivation
, imagemagick
, libwnck
, libxfce4ui
, python3
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-windowck-plugin";
  version = "0.5.0";
  rev-prefix = "v";
  odd-unstable = false;
  sha256 = "sha256-MhNSgI74VLdoS5yL6nfRrVrPvv7+0P5meO4zQheYFzo=";

  buildInputs = [
    imagemagick
    libwnck
    libxfce4ui
    python3
    xfce4-panel
    xfconf
  ];

  postPatch = ''
    patchShebangs themes/windowck{,-dark}/{xfwm4,unity}/generator.py
  '';

  meta = with lib; {
    description = "Xfce panel plugin for displaying window title and buttons";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
