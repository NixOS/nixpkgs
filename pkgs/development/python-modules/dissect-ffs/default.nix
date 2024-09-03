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
  pname = "dissect-ffs";
  version = "3.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ffs";
    rev = "refs/tags/${version}";
    hash = "sha256-PRf3w9s0N3Zfcaoo3RtBEYcv7Ocs4h6V+3XshRI2XXI=";
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

  pythonImportsCheck = [ "dissect.ffs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the FFS file system";
    homepage = "https://github.com/fox-it/dissect.ffs";
    changelog = "https://github.com/fox-it/dissect.ffs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
