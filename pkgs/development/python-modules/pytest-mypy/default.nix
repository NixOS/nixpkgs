{ lib
, buildPythonPackage
, fetchPypi
, filelock
, pytest
, mypy
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-mypy";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fa55723a4bf1d054fcba1c3bd694215a2a65cc95ab10164f5808afd893f3b11";
  };

  nativeBuildInputs = [ setuptools_scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ mypy filelock ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_mypy" ];

  meta = with lib; {
    description = "Mypy static type checker plugin for Pytest";
    homepage = "https://github.com/dbader/pytest-mypy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
