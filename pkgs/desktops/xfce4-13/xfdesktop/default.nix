{ mkXfceDerivation, exo, wrapGAppsHook, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.14pre2";
  rev = "xfce-4.14pre2";

  sha256 = "14sfcxbwxhhwn9nmiap46nz6idvw5hwr8wyjqrhq4h79x78g18k4";

  nativeBuildInputs = [ wrapGAppsHook ]; # fix "No GSettings schemas are installed on the system"

  buildInputs = [
    exo
    gtk3
    libxfce4ui
    libxfce4util
    libwnck3
    xfconf
  ];

  meta = {
    description = "Xfce's desktop manager";
  };
}
