{ lib
, buildPythonPackage
, factory_boy
, faker
, fetchFromGitHub
, importlib-metadata
, numpy
, pytest
, pytest-xdist
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.10.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    sha256 = "sha256-c8Alt3FjhDZ2CrGTe/rEFrDwwA0mjhCK0wA1j7KG54M=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    pytest-xdist
    numpy
    factory_boy
    faker
  ];

  # needs special invocation, copied from tox.ini
  pytestFlagsArray = [ "-p" "no:randomly" ];

  pythonImportsCheck = [ "pytest_randomly" ];

  meta = with lib; {
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
