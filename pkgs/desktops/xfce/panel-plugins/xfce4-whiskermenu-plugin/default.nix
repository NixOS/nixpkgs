{ mkXfceDerivation, gtk3, glib, cmake, exo, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.3.3";
  rev = "v${version}";
  sha256 = "0agh0a5srsy6vi6r50ak9rb42r7vcnfv6nfvg4qbqi77yc44yqdb";

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
