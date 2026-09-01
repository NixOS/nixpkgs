{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  qt6,
  linkFarm,
  hunspellDictsChromium,
  dictionaries ? [
    hunspellDictsChromium.en-us
    hunspellDictsChromium.en-gb
    hunspellDictsChromium.de-de
    hunspellDictsChromium.fr-fr
    hunspellDictsChromium.sv-se
  ],
}:

let
  qtwebengineDictionaries = linkFarm "zapzap-qtwebengine-dictionaries" (
    map (d: {
      name = d.dictFileName;
      path = d;
    }) dictionaries
  );
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zapzap";
  version = "7.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rafatosta";
    repo = "zapzap";
    tag = finalAttrs.version;
    hash = "sha256-8qyMUNFngWJtbyUOB6tRhXvUnZDq/yaLgM6OWdiuzxw=";
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
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      ${lib.optionalString (dictionaries != [ ]) ''
        --set-default QTWEBENGINE_DICTIONARIES_PATH "${qtwebengineDictionaries}"
      ''}
    )
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
