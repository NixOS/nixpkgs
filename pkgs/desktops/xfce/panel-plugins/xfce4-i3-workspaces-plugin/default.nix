{ lib, stdenv, fetchFromGitHub, pkg-config, intltool, gtk3
, libxfce4ui, libxfce4util, xfconf, xfce4-dev-tools, xfce4-panel
, i3ipc-glib
}:

stdenv.mkDerivation rec {
  pname = "xfce4-i3-workspaces-plugin";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "denesb";
    repo = "xfce4-i3-workspaces-plugin";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Ss3uUmNvBqiu7hUaSy98+YYrWs64LFGbV4DMAV+xkvA=";
=======
    sha256 = "sha256-+tjxMr0UbE3BLdxBwNr2mZqKSQOOtw69FmN4rk4loyA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = with maintainers; [ berbiche ] ++ teams.xfce.members;
  };
}
