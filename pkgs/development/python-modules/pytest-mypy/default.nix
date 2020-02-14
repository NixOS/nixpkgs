{ lib
, buildPythonPackage
, fetchPypi
, pytest
, mypy
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a5338cecff17f005b181546a13e282761754b481225df37f33d37f86ac5b304";
  };

  propagatedBuildInputs = [ pytest mypy ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = https://github.com/dbader/pytest-mypy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
