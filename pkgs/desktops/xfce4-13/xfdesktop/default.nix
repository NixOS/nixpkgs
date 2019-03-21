{ mkXfceDerivation, exo, gtk3, libxfce4ui, libxfce4util, libwnck3, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfdesktop";
  version = "4.13.2";

  sha256 = "0v6dlhraqh9v20qciyj03cbjmg3jb6gvmf0hqzavxqi2di3mv5fl";

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
