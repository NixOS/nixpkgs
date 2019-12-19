{ lib
, buildPythonPackage
, fetchPypi
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b823b03faf5778d1e15fb9f52e104df4da9c1021daeb313b339fccbbfb8dbd5f";
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

