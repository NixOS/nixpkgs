{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "duration-parser";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adriansahlman";
    repo = "duration-parser";
    tag = "v${version}";
    hash = "sha256-Vn3H2JEMrJ6b/7eNG+h9tG5QzslGvaV3sunM7UO9Bok=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "duration_parser"
  ];

  meta = {
    description = "Minimal duration parser written in python";
    homepage = "https://github.com/adriansahlman/duration-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
