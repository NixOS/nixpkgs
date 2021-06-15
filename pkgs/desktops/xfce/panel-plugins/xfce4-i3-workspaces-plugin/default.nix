{ lib, stdenv, fetchFromGitHub, pkg-config, intltool, gtk3
, libxfce4ui, libxfce4util, xfconf, xfce4-dev-tools, xfce4-panel
, i3ipc-glib
}:

stdenv.mkDerivation rec {
  pname = "xfce4-i3-workspaces-plugin";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "denesb";
    repo = "xfce4-i3-workspaces-plugin";
    rev = version;
    sha256 = "sha256-+tjxMr0UbE3BLdxBwNr2mZqKSQOOtw69FmN4rk4loyA=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  buildInputs = [
    gtk3
    xfconf
    libxfce4ui
    libxfce4util
    xfce4-dev-tools
    xfce4-panel
    i3ipc-glib
   ];

  preConfigure = ''
    ./autogen.sh
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/denesb/xfce4-i3-workspaces-plugin";
    description = "Workspace switcher plugin for xfce4-panel which can be used for the i3 window manager";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.berbiche ];
  };
}
