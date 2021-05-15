{ lib, stdenv, fetchFromGitHub, pkg-config, intltool, python3, imagemagick, libwnck3, libxfce4ui, xfce4-panel, xfconf, xfce4-dev-tools, xfce }:

stdenv.mkDerivation rec {
  pname  = "xfce4-windowck-plugin";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "invidian";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l066a174v2c7ly125v9x1fgbg5bnpwdwnjh69v9kp4plp791q4n";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    python3
    imagemagick
    libwnck3
    libxfce4ui
    xfce4-panel
    xfconf
    xfce4-dev-tools
  ];

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

  meta = with lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/xfce4-windowck-plugin";
    description = "Xfce plugins which allows to put the maximized window title and buttons on the panel";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.volth ];
  };
}
