{ lib, stdenv, fetchFromGitHub, pkg-config, intltool, python3, imagemagick, libwnck, libxfce4ui, xfce4-panel, xfconf, xfce4-dev-tools, xfce, gitUpdater }:

stdenv.mkDerivation rec {
  pname  = "xfce4-windowck-plugin";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "invidian";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-luCQzqWX3Jl2MlBa3vi1q7z1XOhpFxE8PUxscoIyBlA=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    python3
    imagemagick
    libwnck
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

  passthru.updateScript = gitUpdater {
    inherit pname version;
    attrPath = "xfce.${pname}";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://goodies.xfce.org/projects/panel-plugins/xfce4-windowck-plugin";
    description = "Xfce plugins which allows to put the maximized window title and buttons on the panel";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ volth ] ++ teams.xfce.members;
  };
}
