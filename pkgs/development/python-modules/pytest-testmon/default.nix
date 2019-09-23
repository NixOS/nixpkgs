{ lib
, buildPythonPackage
, fetchPypi
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "0.9.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05648f9b22aeeda9d32e61b46fa78c9ff28f217d69005b3b19ffb75d5992187e";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ coverage ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest --deselect=test/test_testmon.py::TestmonDeselect::test_dependent_testmodule
  '';

  meta = with lib; {
    homepage = "https://github.com/tarpas/pytest-testmon/";
    description = "This is a py.test plug-in which automatically selects and re-executes only tests affected by recent changes";
    license = licenses.mit;
    maintainers = [ maintainers.dmvianna ];
  };
}

