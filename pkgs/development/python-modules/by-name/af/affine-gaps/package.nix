{
  biopython,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  hatchling,
  lib,
  numpy,
  pytest-repeat,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "affine-gaps";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gata-bio";
    repo = "affine-gaps";
    tag = "v${version}";
    hash = "sha256-GP6Ahp1LQYnKp9V7jDEeFsntMC9Qav5kWm+5bSldtyM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    colorama
    numpy
  ];

  pythonImportsCheck = [ "affine_gaps" ];

  nativeCheckInputs = [
    biopython
    pytest-repeat
    pytestCheckHook
  ];

  enabledTestPaths = [ "test.py" ];

  meta = {
    changelog = "https://github.com/gata-bio/affine-gaps/releases/tag/${src.tag}";
    homepage = "https://github.com/gata-bio/affine-gaps";
    license = lib.licenses.asl20;
    mainProgram = "affine-gaps";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
