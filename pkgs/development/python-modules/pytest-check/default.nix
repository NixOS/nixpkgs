{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "2.2.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-3rN/iB36DV4kbymWI4rvdFp5ANezUjp0FgV3K4osSVI=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}
