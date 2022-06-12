{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "1.0.5";
  format = "flit";

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    sha256 = "sha256-ucjbax3uPB5mFivQebgcCDKWy3Ex6YQVGcKKQIGKSHU=";
  };

  buildInputs = [ pytest ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}
