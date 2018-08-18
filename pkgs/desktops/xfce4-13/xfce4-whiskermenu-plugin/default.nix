{ mkXfceDerivation, dbus-glib, gtk3, cmake, exo, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation rec {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.2.0";
  rev = "v${version}";
  sha256 = "1d35xxkdzw8pl3d5ps226mmrrjk0hqczsbvl5smh7l7jbwfambjm";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ dbus-glib exo garcon gtk3 libxfce4ui libxfce4util xfce4-panel xfconf ];

  postInstall = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4-panel.out}/bin/xfce4-panel
  '';
}
