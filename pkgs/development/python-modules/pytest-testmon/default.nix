{ lib
, buildPythonPackage
, fetchPypi
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "0.9.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f622fd9d0f5a0df253f0e6773713c3df61306b64abdfb202d39a85dcba1d1f59";
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

