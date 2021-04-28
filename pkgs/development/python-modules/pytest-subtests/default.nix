{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.4.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jZ4sHR3OEfe30snQkgLr/HdXt/8MrJtyrTKO3+fuA3s=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_subtests" ];

  meta = with lib; {
    description = "pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
