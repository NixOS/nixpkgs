{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, factory_boy, faker, numpy, importlib-metadata
, pytestCheckHook, pytest-xdist
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.10.1";

  disabled = pythonOlder "3.6";

  # fetch from GitHub as pypi tarball doesn't include tests
  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    sha256 = "10z7hsr8yd80sf5113i61p0g1c0nqkx7p4xi19v3d133f6vjbh3k";
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

  meta = with lib; {
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
