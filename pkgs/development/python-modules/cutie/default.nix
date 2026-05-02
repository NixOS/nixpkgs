{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  colorama,
  readchar,
}:

buildPythonPackage (finalAttrs: {
  pname = "cutie";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-B5je6Y5x2E68AaElFVyNlMlsydBM9pKU2Lmmjt2TaW0=";
  };

  patches = [
    ./imp-to-importlib.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    readchar
  ];

  meta = {
    changelog = "https://github.com/Kamik423/cutie/releases/tag/${finalAttrs.version}";
    description = "Toolkit for TUI prompts";
    homepage = "https://github.com/Kamik423/cutie";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chordtoll ];
  };
})
