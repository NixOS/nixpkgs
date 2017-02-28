{ stdenv, fetchFromGitHub, pkgconfig, intltool, python3, imagemagick, libwnck, gtk2
, exo, libxfce4ui, libxfce4util, xfce4panel, xfconf, xfce4_dev_tools }:

stdenv.mkDerivation rec {
  p_name  = "xfce4-windowck-plugin";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "cedl38";
    repo = "xfce4-windowck-plugin";
    rev = "v${version}";
    sha256 = "0c6a1ibh39dpq9x0dha5lsg0vzmgaf051fgwz0nlky0s94nwzvgv";
  };
  name = "${p_name}-${version}";

  buildInputs = [ pkgconfig intltool python3 imagemagick libwnck gtk2
    exo libxfce4ui libxfce4util xfce4panel xfconf xfce4_dev_tools ];

  preConfigure = ''
    ./autogen.sh
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://goodies.xfce.org/projects/panel-plugins/${p_name}";
    description = "Set of two plugins which allows you to put the maximized window title and windows buttons on the panel";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.volth ];
  };
}
