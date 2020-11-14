{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.0.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "927a73dd510b90a2e4a48ea4d37e82c4490b56caa745663262024ea0cd278169";
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

