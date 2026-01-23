{
  lib,
  buildPythonPackage,
  factory-boy,
  faker,
  fetchFromGitHub,
  numpy,
  pytest,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pytest-randomly";
    owner = "pytest-dev";
    tag = version;
    hash = "sha256-bxbW22Nf/0hfJYSiz3xdrNCzrb7vZwuVvSIrWl0Bkv4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    factory-boy
    faker
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
