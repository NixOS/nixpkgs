{ lib
, buildPythonPackage
, factory_boy
, faker
, fetchFromGitHub
, importlib-metadata
, numpy
, pytest-xdist
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    hash = "sha256-n/Xp/HghqcQUreez+QbR3Mi5hE1U4zoOJCdFqD+pVBk=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  checkInputs = [
    factory_boy
    faker
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  # needs special invocation, copied from tox.ini
  pytestFlagsArray = [
    "-p"
    "no:randomly"
  ];

  pythonImportsCheck = [
    "pytest_randomly"
  ];

  meta = with lib; {
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
