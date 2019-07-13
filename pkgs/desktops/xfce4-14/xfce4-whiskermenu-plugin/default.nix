{ mkXfceDerivation, dbus-glib, gtk3, cmake, exo, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.3.2";
  rev = "v${version}";
  sha256 = "0ha6c259d7a0wzpf87ynyzpj3y178iwhpcb87m9zxm66i513qmbs";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ dbus-glib exo garcon gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  postInstall = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4-panel.out}/bin/xfce4-panel
  '';
}
