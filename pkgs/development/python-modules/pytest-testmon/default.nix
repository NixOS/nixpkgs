{ lib
, buildPythonPackage
, fetchPypi
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fdb016d953036051d1ef0e36569b7168cefa4914014789a65a4ffefc87f85ac5";
  };

  propagatedBuildInputs = [ coverage ];

  checkInputs = [ pytest ];

  # avoid tests which try to import unittest_mixins
  # unittest_mixins doesn't seem to be very active
  checkPhase = ''
    cd test
    pytest test_{core,process_code,pytest_assumptions}.py
  '';

  meta = with lib; {
    homepage = "https://github.com/tarpas/pytest-testmon/";
    description = "This is a py.test plug-in which automatically selects and re-executes only tests affected by recent changes";
    license = licenses.mit;
    maintainers = [ maintainers.dmvianna ];
  };
}

