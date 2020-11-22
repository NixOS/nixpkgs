{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.0.2";
  disabled = pythonOlder "3.6";

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
    # test_core.py and test_process_code.py should also be tested here, but tests
    # were broken on version 1.0.3
    # https://github.com/tarpas/pytest-testmon/issues/158
    pytest test_pytest_assumptions.py
  '';

  meta = with lib; {
    homepage = "https://github.com/tarpas/pytest-testmon/";
    description = "This is a py.test plug-in which automatically selects and re-executes only tests affected by recent changes";
    license = licenses.mit;
    maintainers = [ maintainers.dmvianna ];
  };
}

