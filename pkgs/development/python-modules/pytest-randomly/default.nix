{
  lib,
  buildPythonPackage,
  factory-boy,
  faker,
  fetchFromGitHub,
  importlib-metadata,
  model-bakery,
  numpy,
  pytest,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-randomly";
    rev = "refs/tags/${version}";
    hash = "sha256-/5EZ5rRrk8H6YbZIfZlndc9g+5amRb3Gtw3/ZMiiRxs=";
  };

  build-system = [ setuptools ];

  build-input = [ pytest ];

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  nativeCheckInputs = [
    factory-boy
    faker
    model-bakery
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  # needs special invocation, copied from tox.ini
  pytestFlagsArray = [
    "-p"
    "no:randomly"
  ];

  pythonImportsCheck = [ "pytest_randomly" ];

  meta = with lib; {
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    changelog = "https://github.com/pytest-dev/pytest-randomly/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
