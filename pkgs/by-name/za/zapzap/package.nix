{ lib
, fetchFromGitHub
, python3Packages
, qt6
, fetchpatch
}:

python3Packages.buildPythonApplication rec {
  pname = "zapzap";
  version = "4.5.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zapzap-linux";
    repo = "zapzap";
    rev = version;
    hash = "sha256-8IeFGTI+5kbeFGqH5DpHCY8pqzGhE48hPCEIKIe7jAM=";
  };

  patches = [
    # fixes that the tray icon was not installed
    (fetchpatch {
      url = "https://github.com/zapzap-linux/zapzap/pull/25/commits/4107b019555492e2c2692dd4c40553503047e6a8.patch";
      hash = "sha256-NQPGPXYFhVwsPXopEELG1n/f8yUj/74OFE1hTyt93Ng=";
    })
  ];

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
