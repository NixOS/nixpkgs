{ mkXfceDerivation, gtk3, glib, cmake, exo, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.4.3";
  rev = "v${version}";
  sha256 = "1cs3fps1bj0dd5az7fwrvw1xl3y621qk4dma3n73p7rr19j7fpsn";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ exo garcon gtk3 glib libxfce4ui libxfce4util xfce4-panel xfconf ];

  postInstall = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4-panel.out}/bin/xfce4-panel
  '';

  meta = {
    description = "Alternate application launcher for Xfce";
  };
}
