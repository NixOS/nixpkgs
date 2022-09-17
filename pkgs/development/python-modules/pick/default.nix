{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pick";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wong2";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-fuhQFytJCVmNlMiqhuM6xD+BjmLMX3quPAyJNHE/cdY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pick"
  ];

  meta = with lib; {
    description = "Module to create curses-based interactive selection list in the terminal";
    homepage = "https://github.com/wong2/pick";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
