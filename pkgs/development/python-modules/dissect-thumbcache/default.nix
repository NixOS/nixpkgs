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
  pname = "dissect-thumbcache";
  version = "1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.thumbcache";
    tag = version;
    hash = "sha256-yZAowAPQGfYl8RcCcnR5yPiiaY2s7LykRqgVeKThkpk=";
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

  pythonImportsCheck = [ "dissect.thumbcache" ];

  disabledTests = [
    # Don't run Windows related tests
    "windows"
    "test_index_type"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Windows thumbcache";
    homepage = "https://github.com/fox-it/dissect.thumbcache";
    changelog = "https://github.com/fox-it/dissect.thumbcache/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
