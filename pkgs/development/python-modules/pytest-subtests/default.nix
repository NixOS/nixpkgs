{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Rus3YCLpJpUIFszCNQLeMnetzBOWZS3bMyjOAokFLE0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_subtests"
  ];

  meta = with lib; {
    description = "Pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
