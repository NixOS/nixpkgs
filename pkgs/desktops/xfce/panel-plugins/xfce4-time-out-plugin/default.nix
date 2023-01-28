{ lib, mkXfceDerivation, gtk3, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-time-out-plugin";
  version = "1.1.2";
  rev-prefix = "xfce4-time-out-plugin-";
  odd-unstable = false;
  sha256 = "sha256-xfkQjlUfvm0YXs3bRJD4W/71VkaPq3Y+cDFVNiL/bjc=";

  buildInputs = [
    gtk3 libxfce4ui libxfce4util xfce4-panel xfconf
  ];

  meta = with lib; {
    description = "Panel plug-in to take periodical breaks from the computer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
