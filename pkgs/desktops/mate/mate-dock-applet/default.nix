{ lib
, fetchFromGitHub
, autoreconfHook
, bamf
, gobject-introspection
, libnotify
, libwnck
, mate-panel
, pkg-config
, python3Packages
, wrapGAppsHook
, gitUpdater
}:

python3Packages.buildPythonApplication rec {
  pname = "mate-dock-applet";
  version = "21.10.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "ubuntu-mate";
    repo = pname;
    rev = version;
    hash = "sha256-5RqOPUnxGNq/YDfKIOk2paRlQ8Y/AxWePi9HlAMfR/8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    libnotify
    libwnck
    mate-panel
  ];

  pythonPath = with python3Packages; [
    dbus-python
    distro
    pillow
    pycairo
    pygobject3
    pyxdg
    xlib
  ];

  postPatch = ''
    substituteInPlace src/org.mate.panel.applet.DockAppletFactory.service.in \
      --replace "/usr/bin/env python3 " ""
  '';

  configureFlags = [
    "--with-gtk3"
  ];

  postFixup = ''
    wrapGApp $out/lib/mate-applets/${pname}/dock_applet.py \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Application dock for the MATE panel";
    homepage = "https://github.com/ubuntu-mate/mate-dock-applet";
    changelog = "https://github.com/ubuntu-mate/mate-dock-applet/releases/tag/${version}";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = teams.mate.members;
  };
}
