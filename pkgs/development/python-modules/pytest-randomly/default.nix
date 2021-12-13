{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, factory_boy, faker, numpy, importlib-metadata
, pytestCheckHook, pytest-xdist
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.10.3";

  disabled = pythonOlder "3.6";

  # fetch from GitHub as pypi tarball doesn't include tests
  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    sha256 = "0xw0xkk568za10y6r31my0qg378njklm5272sfcrvksnj4r2k1in";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
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
    maintainers = [ maintainers.sternenseemann ];
  };
}
