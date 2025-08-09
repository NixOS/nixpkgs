{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  scipy,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "open-hypergraphs";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "statusfailed";
    repo = "open-hypergraphs";
    tag = "pypi-${version}";
    hash = "sha256-ifcQXZDnOvo2XL7WYVFLv2iHWhImUSp3jqAPPYySNjU=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonRelaxDeps = [
    "numpy"
    "scipy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [
    "open_hypergraphs"
  ];

  meta = {
    description = "Implementation of open hypergraphs for string diagrams";
    homepage = "https://github.com/statusfailed/open-hypergraphs";
    changelog = "https://github.com/statusfailed/open-hypergraphs/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
