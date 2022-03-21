{ lib
, appdirs
, buildPythonPackage
, fetchFromGitHub
, platformdirs
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "platformdirs";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-fppwtY8VX8IQ96H930xItO7mS8LlxxHgBcKlwIL5P2E=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "platformdirs"
  ];

  meta = with lib; {
    description = "Python module for determining appropriate platform-specific directories";
    homepage = "https://platformdirs.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
