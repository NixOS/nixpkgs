{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "2.2.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    hash = "sha256-eufpnpDxJ9PQLSnAKostlbWofbPTDczRaen9ZsRP2+g=";
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
