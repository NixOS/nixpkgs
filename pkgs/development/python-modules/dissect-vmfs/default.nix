{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-vmfs";
  version = "3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.vmfs";
    tag = version;
    hash = "sha256-4c3JVbQidGvXurWaO+/E0OehGgiY5shE5BiIBwMrCWM=";
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

  pythonImportsCheck = [ "dissect.vmfs" ];

  disabledTests = [
    # Archive not present
    "test_huge"
    "test_lvm_basic"
    "test_lvm_span"
    "test_sparse"
    "test_vmfs_basic"
    "test_vmfs_content"
    "test_vmfs_jbosf"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the VMFS file system";
    homepage = "https://github.com/fox-it/dissect.vmfs";
    changelog = "https://github.com/fox-it/dissect.vmfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
