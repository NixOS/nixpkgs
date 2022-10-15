{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "1.0.10";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ng7c10Dyxb5qbO22TDkNl5wAzXg2eYrLO21sjtEBoio=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}
