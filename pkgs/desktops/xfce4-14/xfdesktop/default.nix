{ mkXfceDerivation, exo, wrapGAppsHook, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.14.1";

  sha256 = "006w4xwmpwp34q2qkkixr3xz0vb0kny79pw64yj4304wsb5jr14g";

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
