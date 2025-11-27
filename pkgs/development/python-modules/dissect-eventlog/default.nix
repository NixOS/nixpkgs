{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-eventlog";
  version = "3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.eventlog";
    tag = version;
    hash = "sha256-q9pbNBtTnrq7E8faW0a9v63oh7/8r9njeZOZeUFpt2k=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.eventlog" ];

  meta = with lib; {
    description = "Dissect module implementing parsers for the Windows EVT, EVTX and WEVT log file formats";
    homepage = "https://github.com/fox-it/dissect.eventlog";
    changelog = "https://github.com/fox-it/dissect.eventlog/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
