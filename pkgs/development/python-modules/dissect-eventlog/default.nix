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
  version = "3.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.eventlog";
    rev = "refs/tags/${version}";
    hash = "sha256-dU34eEUwRGHm/S0w6rnXJmootv1trkhKlXjWcfCFB3Q=";
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
