{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "zapzap";
  version = "6.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rafatosta";
    repo = "zapzap";
    tag = version;
    hash = "sha256-8SUwb7W2K6jnj94LOt0vX8aI9EuOnMKR8nclWFhaTBw=";
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

  meta = with lib; {
    description = "WhatsApp desktop application written in Pyqt6 + PyQt6-WebEngine";
    homepage = "https://rtosta.com/zapzap/";
    mainProgram = "zapzap";
    license = licenses.gpl3Only;
    changelog = "https://github.com/rafatosta/zapzap/releases/tag/${src.tag}";
    maintainers = [ maintainers.eymeric ];
  };
}
