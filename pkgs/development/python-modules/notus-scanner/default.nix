{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, poetry-core
, psutil
, pytestCheckHook
, python-gnupg
, pythonOlder
, pythonRelaxDepsHook
, sentry-sdk
, tomli
}:

buildPythonPackage rec {
  pname = "notus-scanner";
  version = "22.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-V70cFSfQ9SuLhCSUa8DuYA7qaabwiK9IbIkYcQMgVUk=";
  };

  pythonRelaxDeps = [
    "python-gnupg"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    paho-mqtt
    psutil
    python-gnupg
    sentry-sdk
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "notus.scanner"
  ];

  meta = with lib; {
    description = "Helper to create results from local security checks";
    homepage = "https://github.com/greenbone/notus-scanner";
    changelog = "https://github.com/greenbone/notus-scanner/releases/tag/v${version}";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
