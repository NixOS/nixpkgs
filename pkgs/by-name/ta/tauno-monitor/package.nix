{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  appstream,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  libadwaita,
}:
python3Packages.buildPythonApplication rec {
  pname = "tauno-monitor";
  version = "0.2.17";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "taunoe";
    repo = "tauno-monitor";
    tag = "v${version}";
    hash = "sha256-klYL9A2E7MsgzX9Aj0nrmaKWjvzI3giZVZVvFot16XU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    appstream
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    pyserial
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Simple serial port monitor";
    homepage = "https://github.com/taunoe/tauno-monitor";
    changelog = "https://github.com/taunoe/tauno-monitor/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "tauno-monitor";
  };
}
