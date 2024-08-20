{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-eventlog";
  version = "3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.eventlog";
    rev = "refs/tags/${version}";
    hash = "sha256-MXjWHbw/iEzKo4cgiYAHLzt6/Y7s9o9cPNV5TD0gqW8=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.eventlog" ];

  meta = with lib; {
    description = "Dissect module implementing parsers for the Windows EVT, EVTX and WEVT log file formats";
    homepage = "https://github.com/fox-it/dissect.eventlog";
    changelog = "https://github.com/fox-it/dissect.eventlog/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
