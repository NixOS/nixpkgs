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
  version = "3.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    hash = "sha256-M9Z6IK5R1TDlVynZYo5K4nOz0qkx/wr3OAk59BLBT+o=";
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
