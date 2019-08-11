{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-remotedata";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b75a38431da96a4da5e48b20a18e4dcc40d191abc199b17cb969f818530481";
  };

  propagatedBuildInputs = [
    six
    pytest
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # these tests require a network connection
    pytest --ignore tests/test_strict_check.py
  '';

  meta = with lib; {
    description = "Pytest plugin for controlling remote data access";
    homepage = https://astropy.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
