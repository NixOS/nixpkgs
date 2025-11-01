{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitea,
  flake8,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "clickclick";
  version = "20.10.2";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "hjacobs";
    repo = "python-clickclick";
    rev = version;
    hash = "sha256-gefU6CI4ibtvonsaKZmuffuUNUioBn5ODs72BI5zXOw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flake8
    click
    pyyaml
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "clickclick" ];

  disabledTests = [
    # Tests asserts on exact quoting style of output
    "test_choice_default"
    "test_cli"
  ];

  meta = with lib; {
    description = "Click command line utilities";
    homepage = "https://codeberg.org/hjacobs/python-clickclick/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
