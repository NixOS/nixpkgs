{
  lib,
  buildPythonPackage,
  factory-boy,
  faker,
  fetchFromGitHub,
  model-bakery,
  numpy,
  pytest,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pytest-randomly";
    owner = "pytest-dev";
    tag = version;
    hash = "sha256-UQ1G9o4dsVEEo4y2u1TYYurJPfih7QlbilkwPqi39H0=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    factory-boy
    faker
    model-bakery
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  # needs special invocation, copied from tox.ini
  pytestFlags = [
    "-pno:randomly"
  ];

  pythonImportsCheck = [ "pytest_randomly" ];

  meta = {
    changelog = "https://github.com/pytest-dev/pytest-randomly/blob/${src.tag}/CHANGELOG.rst";
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
