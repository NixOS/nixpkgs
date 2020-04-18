{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytest
, pylint
, six
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.15.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sbmnw3bly4pry5lp6q6g0r8xzaxwbdlf0k19k8pygkhllnj6gnx";
  };

  buildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    pytest
    pylint
    six
  ];

  # tests not included with release
  doCheck = false;

  meta = with lib; {
    description = "pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
