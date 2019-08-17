{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.14.1";

  sha256 = "006w4xwmpwp34q2qkkixr3xz0vb0kny79pw64yj4304wsb5jr14g";

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
