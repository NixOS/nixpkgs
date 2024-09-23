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
  pname = "dissect-ntfs";
  version = "3.12";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ntfs";
    rev = "refs/tags/${version}";
    hash = "sha256-zRAZqziVS4I7FDa7E4j67ekl9FXt0X+0oUpwmpNeI+I=";
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

  pythonImportsCheck = [ "dissect.ntfs" ];

  disabledTestPaths = [
    # Test is very time consuming
    "tests/test_index.py"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the NTFS file system";
    homepage = "https://github.com/fox-it/dissect.ntfs";
    changelog = "https://github.com/fox-it/dissect.ntfs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
