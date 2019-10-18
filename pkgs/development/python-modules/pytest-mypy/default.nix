{ lib
, buildPythonPackage
, fetchPypi
, pytest
, mypy
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "917438af835beb87f14c9f6261137f8e992b3bf87ebf73f836ac7ede03424a0f";
  };

  propagatedBuildInputs = [ pytest mypy ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = https://github.com/dbader/pytest-mypy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
