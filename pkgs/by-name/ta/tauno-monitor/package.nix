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
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tauno-monitor";
  version = "0.2.18";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "taunoe";
    repo = "tauno-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UkBEronqxvf3wAqMUvTbvIjYZSe4Y53ZU3JklzK4Na0=";
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
    changelog = "https://github.com/taunoe/tauno-monitor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "tauno-monitor";
  };
})
