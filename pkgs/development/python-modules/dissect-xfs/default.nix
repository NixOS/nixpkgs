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
  pname = "dissect-xfs";
  version = "3.12";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.xfs";
    tag = version;
    hash = "sha256-DKM6z5lasvy2Is64W2lvClgpXslTgNehrfBpa/KtkT0=";
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

  pythonImportsCheck = [ "dissect.xfs" ];

  # Archive files seems to be corrupt
  doCheck = false;

  meta = with lib; {
    description = "Dissect module implementing a parser for the XFS file system";
    homepage = "https://github.com/fox-it/dissect.xfs";
    changelog = "https://github.com/fox-it/dissect.xfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
