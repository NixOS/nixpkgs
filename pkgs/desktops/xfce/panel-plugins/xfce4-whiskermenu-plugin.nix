{ stdenv, fetchFromGitHub, cmake, pkgconfig, intltool, libxfce4util, libxfcegui4
, xfce4panel, gtk, exo, garcon }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-whiskermenu-plugin";
  version = "1.7.2";

  name = "${p_name}-${version}";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "xfce4-whiskermenu-plugin";
    rev = "v${version}";
    sha256 = "1rpazgnjp443abc31bgi6gp9q3sgbg13v7v74nn7vf6kl4v725ah";
  };

  nativeBuildInputs = [ cmake pkgconfig intltool ];

  buildInputs = [ libxfce4util libxfcegui4 xfce4panel gtk exo garcon ];

  enableParallelBuilding = true;

  preFixup = ''
    substituteInPlace $out/bin/xfce4-popup-whiskermenu \
      --replace $out/bin/xfce4-panel ${xfce4panel.out}/bin/xfce4-panel
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Alternate application launcher for Xfce";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.pjbarnoy ];
  };
}
