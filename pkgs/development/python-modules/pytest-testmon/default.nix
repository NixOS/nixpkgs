{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.2.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e69d5aeac4e371986f94e8ad06e56d70633870d026f2306fca44051f02fcb688";
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

