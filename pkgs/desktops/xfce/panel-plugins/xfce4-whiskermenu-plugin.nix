{ stdenv, fetchFromGitHub, cmake, pkgconfig, intltool, libxfce4util, libxfcegui4
, xfce4panel, gtk, exo, garcon }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-whiskermenu-plugin";
  ver_maj = "1.5";
  ver_min = "1";
  rev = "18c31a357c102ab38e98ac24c154f9e6187b3ef8";

  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "xfce4-whiskermenu-plugin";
    inherit rev;
    sha256 = "442e887877ffc347378c23ded2466ebbfc7aacb6b91fc395b12071320616eb76";
  };

  buildInputs = [ cmake pkgconfig intltool libxfce4util libxfcegui4 xfce4panel
                  gtk exo garcon ];

  preFixup = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4panel}/bin/xfce4-panel
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Whisker Menu is an alternate application launcher for Xfce.";
    platforms = platforms.linux;
    maintainers = [ maintainers.pjbarnoy ];
  };
}
