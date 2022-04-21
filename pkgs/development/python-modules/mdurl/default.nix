{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdurl";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-SBJSs+i+I0jF90i3o6BUgLCDR6Et34fXEmQ7fbDoAbA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mdurl"
  ];

  meta = with lib; {
    description = "URL utilities for markdown-it";
    homepage = "https://github.com/hukkin/mdurl";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
