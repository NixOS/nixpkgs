{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-archive";
  version = "1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.archive";
    tag = version;
    hash = "sha256-HNbnluJPn275BYEdfBQdGtXlXlvZKFvDkJTpe0zgpdc=";
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

  pythonImportsCheck = [ "dissect.archive" ];

  disabledTests = [
    # Issue with archives
    "test_vbk"
    "test_vma"
    "test_wim"
  ];

  meta = with lib; {
    description = "Dissect module implementing parsers for various archive and backup formats";
    homepage = "https://github.com/fox-it/dissect.archive";
    changelog = "https://github.com/fox-it/dissect.archive/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
