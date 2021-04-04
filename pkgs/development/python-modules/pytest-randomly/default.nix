{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, factory_boy, faker, numpy, backports-entry-points-selectable
, pytestCheckHook, pytest_xdist
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.6.0";

  disabled = pythonOlder "3.6";

  # fetch from GitHub as pypi tarball doesn't include tests
  src = fetchFromGitHub {
    repo = pname;
    owner = "pytest-dev";
    rev = version;
    sha256 = "17s7gx8b7sl7mp77f5dxzwbb32qliz9awrp6xz58bhjqp7pcsa5h";
  };

  propagatedBuildInputs = [
    backports-entry-points-selectable
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
