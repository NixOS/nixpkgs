{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pick";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wong2";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rpUcWMVshlAhprvySqJJjVXpq92ITuhlV+DNwTXSfMc=";
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
    Changelog = "https://github.com/wong2/pick/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
