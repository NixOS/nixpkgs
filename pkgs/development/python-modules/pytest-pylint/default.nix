{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pylint
, six
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bfbb66fc6dc160193a9e813a7c55e5ae32028f18660deeb90e1cb7e980cbbac";
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
    homepage = https://github.com/carsongee/pytest-pylint;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
