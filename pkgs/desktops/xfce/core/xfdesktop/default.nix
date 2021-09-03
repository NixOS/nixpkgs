{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck, xfconf, libnotify, garcon, thunar }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.16.0";

  sha256 = "sha256-w/JNjyAlxZqfVpm8EBt+ieHhUziOtfd//XHzIjJjy/4=";

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libwnck
    xfconf
    libnotify
    garcon
    thunar
  ];

  meta = {
    description = "Xfce's desktop manager";
  };
}
