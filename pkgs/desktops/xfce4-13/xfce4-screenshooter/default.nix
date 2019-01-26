{ mkXfceDerivation, exo, gtk3, libsoup, libxfce4ui, libxfce4util, xfce4-panel, wrapGAppsHook, glib-networking }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.9.2";

  sha256 = "1zl16xcmgrb1s6rsrn37mpl5w522i1i9s7x167xf2d092x333yx2";

  nativeBuildInputs = [ wrapGAppsHook ]; # fix "No GSettings schemas are installed on the system"
  buildInputs = [ exo gtk3 libsoup libxfce4ui libxfce4util xfce4-panel glib-networking ];
}
