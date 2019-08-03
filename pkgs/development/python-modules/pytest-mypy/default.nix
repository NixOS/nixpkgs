{ lib
, buildPythonPackage
, fetchPypi
, pytest
, mypy
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acc653210e7d8d5c72845a5248f00fd33f4f3379ca13fe56cfc7b749b5655c3e";
  };

  propagatedBuildInputs = [ pytest mypy ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = https://github.com/dbader/pytest-mypy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
