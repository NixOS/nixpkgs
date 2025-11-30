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
  pname = "dissect-ntfs";
  version = "3.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ntfs";
    tag = version;
    hash = "sha256-dd0AGkOXd+7VB6RIGiLoq1AFi4Uns1axW4V8MN8W7ao=";
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

  disabledTests = [
    # Issue with archive
    "test_mft"
    "test_ntfs"
    "test_secure"
    "test_fragmented_mft"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the NTFS file system";
    homepage = "https://github.com/fox-it/dissect.ntfs";
    changelog = "https://github.com/fox-it/dissect.ntfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
