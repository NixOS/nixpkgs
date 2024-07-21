{ lib
, fetchFromGitHub
, python3Packages
, qt6
}:

python3Packages.buildPythonApplication rec {
  pname = "zapzap";
  version = "5.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zapzap-linux";
    repo = "zapzap";
    rev = "refs/tags/${version}";
    hash = "sha256-RDkuYR74vjXnPgiqDCeY6y9yQNvAWAaQfWmfs7xic9E=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtwayland
    qt6.qtsvg
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  propagatedBuildInputs = with python3Packages; [
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

  meta = with lib; {
    description = "WhatsApp desktop application for Linux";
    homepage = "https://zapzap-linux.github.io/";
    mainProgram = "zapzap";
    license = licenses.gpl3Only;
    changelog = "https://github.com/zapzap-linux/zapzap/releases/tag/${version}";
    maintainers = [ maintainers.eymeric ];
  };
}
