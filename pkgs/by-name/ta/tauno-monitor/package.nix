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
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tauno-monitor";
  version = "0.2.24";
  pyproject = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "taunoe";
    repo = "tauno-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HtoXdKKa/2nvBZVUXSrXH/7JHzdQObjW+7QTx/e8IWo=";
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

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple serial port monitor";
    homepage = "https://github.com/taunoe/tauno-monitor";
    changelog = "https://github.com/taunoe/tauno-monitor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "tauno-monitor";
    platforms = lib.platforms.linux;
  };
})
