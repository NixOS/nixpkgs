{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  wcwidth,

  # tests
  coverage,
  pytest-cov-stub,
  pytest-lazy-fixtures,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    tag = version;
    hash = "sha256-18FXxC1j5EWGnKzgNOr0TRRnlRXzQ9IwSe7YGx92Gf4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ wcwidth ];

  nativeCheckInputs = [
    coverage
    pytest-cov-stub
    pytest-lazy-fixtures
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prettytable" ];

  meta = {
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
