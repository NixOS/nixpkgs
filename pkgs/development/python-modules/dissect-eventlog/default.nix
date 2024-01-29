{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-eventlog";
  version = "3.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.eventlog";
    rev = "refs/tags/${version}";
    hash = "sha256-h1LrBt8f9YFkc1uAAb4WwY3LjPuvsdVFvxji3QxKF0A=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.eventlog"
  ];

  meta = with lib; {
    description = "Dissect module implementing parsers for the Windows EVT, EVTX and WEVT log file formats";
    homepage = "https://github.com/fox-it/dissect.eventlog";
    changelog = "https://github.com/fox-it/dissect.eventlog/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
