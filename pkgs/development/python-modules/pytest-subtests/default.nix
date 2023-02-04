{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wDF81fal6z6Vfonb5PwzIqmv3botuEFDVe0qLLkahE4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
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
