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
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.eventlog";
    rev = version;
    hash = "sha256-emNGZs/5LWD29xE5BmXQKQfkZApLZlGs6KNIqobaKvM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.eventlog"
  ];

  meta = with lib; {
    description = "Dissect module implementing parsers for the Windows EVT, EVTX and WEVT log file formats";
    homepage = "https://github.com/fox-it/dissect.eventlog";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
