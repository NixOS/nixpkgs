{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdurl";
  version = "0.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hukkin";
    repo = pname;
    rev = version;
    sha256 = "sha256-AVklWFc4o5R9OzS9BYauuOaxm89P/Ih5l3Vrb2P0El4=";
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
