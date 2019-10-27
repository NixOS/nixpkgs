{ lib
, buildPythonPackage
, fetchPypi
, pytest
, mypy
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6348a3aa08d7b38b05c12ed0965415e1b60d402d7ceb353f5116f6eaf7dac28";
  };

  propagatedBuildInputs = [ pytest mypy ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = https://github.com/dbader/pytest-mypy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
