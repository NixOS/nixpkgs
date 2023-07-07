{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "py-dormakaba-dkey";
  version = "1.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "emontnemery";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1jIsKQa27XNVievU02jjanRWFtJDYsHolgPBab6qpM0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    cryptography
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "py_dormakaba_dkey"
  ];

  meta = with lib; {
    description = "Library to interact with a Dormakaba dkey lock";
    homepage = "https://github.com/emontnemery/py-dormakaba-dkey";
    changelog = "https://github.com/emontnemery/py-dormakaba-dkey/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
