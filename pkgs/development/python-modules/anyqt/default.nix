{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  pytestCheckHook,
  qt5,
  setuptools,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "anyqt";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ales-erjavec";
    repo = "anyqt";
    tag = finalAttrs.version;
    hash = "sha256-iDUgu+x9rnpxpHzO7Rf2rJFXsheivrK7HI3FUbomkTU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pyqt5
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${lib.getBin qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM=offscreen
  '';

  pythonImportsCheck = [ "AnyQt" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PyQt/PySide compatibility layer";
    homepage = "https://github.com/ales-erjavec/anyqt";
    changelog = "https://github.com/ales-erjavec/anyqt/releases/tag/${finalAttrs.version}";
    license = [ lib.licenses.gpl3Only ];
    maintainers = [ lib.maintainers.lucasew ];
  };
})
