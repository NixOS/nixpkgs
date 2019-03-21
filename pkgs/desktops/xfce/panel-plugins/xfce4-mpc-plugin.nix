{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, xfce4-panel, libxfce4ui,
libxfcegui4, xfconf, gtk, exo }:

with stdenv.lib;
stdenv.mkDerivation rec {
  p_name  = "xfce4-mpc-plugin";
  ver_maj = "0.4";
  ver_min = "5";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://xfce/src/panel-plugins/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1kvgq1pq7cykqdc3227dq0izad093ppfw3nfsrcp9i8mi6i5f7z7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool libxfce4util libxfce4ui xfce4-panel
    libxfcegui4 xfconf gtk exo ];

  meta = {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "MPD plugin for Xfce panel";
    platforms = platforms.linux;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
