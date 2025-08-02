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
  pname = "dissect-shellitem";
  version = "3.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.shellitem";
    tag = version;
    hash = "sha256-mHcH6lgTyv1DlEccYRitfby7WMJc3/71ef/OurW3EEw=";
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

  pythonImportsCheck = [ "dissect.shellitem" ];

  # Windows-specific tests
  doCheck = false;

  meta = {
    description = "Dissect module implementing a parser for the Shellitem structures";
    homepage = "https://github.com/fox-it/dissect.shellitem";
    changelog = "https://github.com/fox-it/dissect.shellitem/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "parse-lnk";
  };
}
