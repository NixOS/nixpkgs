{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wyoming-openwakeword";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-openwakeword";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yYDZ1wOhCTdYGeRmtbOgx5/zkF0Baxmha7eO/i0p49g=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "wyoming"
  ];

  dependencies = with python3Packages; [
    pyopen-wakeword
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_openwakeword"
  ];

  meta = {
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "wyoming-openwakeword";
  };
})
