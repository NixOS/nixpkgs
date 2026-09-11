{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gettext,
  glib,
  desktop-file-utils,
  appstream-glib,
  gobject-introspection,
  libadwaita,
  nix-update-script,
}:
let
  version = "1.0.1";
in
python3Packages.buildPythonApplication {
  pname = "teleprompter";
  inherit version;
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "teleprompter";
    tag = "v${version}";
    hash = "sha256-KnjZJbTM5EH/0aitqCtohE3Xy4ixOsDMthUn8kWjHq8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    glib
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  pythonPath = [ python3Packages.pygobject3 ];

  buildInputs = [ libadwaita ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stay on track during speeches";
    homepage = "https://github.com/Nokse22/teleprompter";
    changelog = "https://github.com/Nokse22/teleprompter/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "teleprompter";
    maintainers = [ lib.maintainers.da157 ];
  };
}
