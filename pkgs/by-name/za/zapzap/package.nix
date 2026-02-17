{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zapzap";
  version = "6.2.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rafatosta";
    repo = "zapzap";
    tag = finalAttrs.version;
    hash = "sha256-dNHDR9sZWPetdwpS5u0UCn5sCkDMEw5YoE4QBerU2Sg=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtwayland
    qt6.qtsvg
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    dbus-python
    pyqt6
    pyqt6-webengine
    pyqt6-sip
  ];

  postInstall = ''
    install -Dm555 share/applications/com.rtosta.zapzap.desktop -t $out/share/applications/
    install -Dm555 share/icons/com.rtosta.zapzap.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "zapzap" ];

  meta = {
    description = "WhatsApp desktop application written in Pyqt6 + PyQt6-WebEngine";
    homepage = "https://rtosta.com/zapzap/";
    mainProgram = "zapzap";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/rafatosta/zapzap/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ lib.maintainers.eymeric ];
  };
})
