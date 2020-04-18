{ stdenv, fetchFromGitHub, pkgconfig, intltool, python3, imagemagick, libwnck, gtk2
, exo, libxfce4ui, libxfce4util, xfce4-panel, xfconf, xfce4-dev-tools, xfce }:

stdenv.mkDerivation rec {
  pname  = "xfce4-windowck-plugin";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "cedl38";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c6a1ibh39dpq9x0dha5lsg0vzmgaf051fgwz0nlky0s94nwzvgv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool python3 imagemagick libwnck gtk2
    exo libxfce4ui libxfce4util xfce4-panel xfconf xfce4-dev-tools ];

  preConfigure = ''
    ./autogen.sh
    patchShebangs .
  '';

  enableParallelBuilding = true;

  passthru.updateScript = xfce.updateScript {
    inherit pname version;
    attrPath = "xfce.${pname}";
    versionLister = xfce.gitLister src.meta.homepage;
    rev-prefix = "v";
  };

  meta = with stdenv.lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/${pname}";
    description = "Set of two plugins which allows you to put the maximized window title and windows buttons on the panel";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.volth ];
  };
}
