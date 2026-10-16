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
  version = "0.3.6";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "taunoe";
    repo = "tauno-monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QGqT1NqDcy4D6tagvlmSJBrHa1eJN9me053IRv9uI7M=";
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
    matplotlib
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstallCheck = ''
    mesonCheckPhase
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
