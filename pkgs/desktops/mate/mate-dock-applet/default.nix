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
  version = "21.10.0-unstable-2022-10-05";
  format = "other";

  src = fetchFromGitHub {
    owner = "ubuntu-mate";
    repo = pname;
    rev = "1d2c89daa8feb55d77dc200e7872b0312e635ad3";
    hash = "sha256-R0JjN3xc+35Cba7G7Q3ZnpC3nxW+3Vg4EORfgu49mo0=";
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
      --replace-fail "/usr/bin/env python3 " ""
  '';

  configureFlags = [
    "--with-gtk3"
  ];

  postFixup = ''
    wrapGApp $out/lib/mate-applets/${pname}/dock_applet.py \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Application dock for the MATE panel";
    homepage = "https://github.com/ubuntu-mate/mate-dock-applet";
    changelog = "https://github.com/ubuntu-mate/mate-dock-applet/releases/tag/${version}";
    license = [ lib.licenses.gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = lib.teams.mate.members;
  };
}
