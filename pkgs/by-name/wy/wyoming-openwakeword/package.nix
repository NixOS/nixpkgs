{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-openwakeword";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-openwakeword";
    rev = "refs/tags/v${version}";
    hash = "sha256-edSZ5W6oSPYLKuxjQerWRkAO/C+WeTiCosNnbS2sbh0=";
  };

  patches = [
    (fetchpatch {
      # Expose entrypoint as wyoming-openwakeword script
      url = "https://github.com/rhasspy/wyoming-openwakeword/commit/a8c8419bc65fab07a554aa0925f898a7f3b65d79.patch";
      hash = "sha256-GSViQA01RwkFYEH7CPdU1P0EQ2ml6Vp1OukQ/0VOm+Y=";
    })
  ];

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
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/blob/v${version}/CHANGELOG.md";
    description = "Open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "wyoming-openwakeword";
  };
}
