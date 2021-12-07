{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "1.0.4";

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    sha256 = "c93eee5a98bcd28634a4ec657ab62c46d25fa384300811e5a925d9c4d98b9540";
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
