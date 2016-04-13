{ stdenv, fetchFromGitHub, cmake, pkgconfig, intltool, libxfce4util, libxfcegui4
, xfce4panel, gtk, exo, garcon }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-whiskermenu-plugin";
  ver_maj = "1.5";
  ver_min = "2";
  rev = "d08418c8d55edfacef190ec14e03e1e9a6988101";

  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "xfce4-whiskermenu-plugin";
    inherit rev;
    sha256 = "0icphm6bm5p3csh9kwyyvkj2y87shrs12clfifbhv35dm0skb2dx";
  };

  buildInputs = [ cmake pkgconfig intltool libxfce4util libxfcegui4 xfce4panel
                  gtk exo garcon ];

  preFixup = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4panel}/bin/xfce4-panel
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Whisker Menu is an alternate application launcher for Xfce";
    platforms = platforms.linux;
    maintainers = [ maintainers.pjbarnoy ];
  };
}
