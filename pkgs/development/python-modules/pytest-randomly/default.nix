{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, factory_boy, faker, numpy, importlib-metadata
, pytestCheckHook, pytest_xdist
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.8.0";

  disabled = pythonOlder "3.6";

  # fetch from GitHub as pypi tarball doesn't include tests
  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    sha256 = "1v87vpn0whx468gvmv3iqk89g4wpvpl0qnydm85v7hc3zy6n2f9m";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    pytest_xdist
    numpy
    factory_boy
    faker
  ];
  # needs special invocation, copied from tox.ini
  pytestFlagsArray = [ "-p" "no:randomly" ];

  meta = with lib; {
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
