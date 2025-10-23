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
  pname = "dissect-volume";
  version = "3.16";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.volume";
    tag = version;
    hash = "sha256-xJioreloRqxIoM5h1Uh0gLkIel5XScjvMvNWtSu1dqY=";
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

  pythonImportsCheck = [ "dissect.volume" ];

  disabledTests = [
    # gzip.BadGzipFile: Not a gzipped file
    "test_apm"
    "test_bsd"
    "test_bsd64"
    "test_ddf_read"
    "test_dm_thin"
    "test_gpt_4k"
    "test_gpt_esxi_no_name_xff"
    "test_gpt_esxi"
    "test_gpt"
    "test_hybrid_gpt"
    "test_lvm_mirro"
    "test_lvm_thin"
    "test_lvm"
    "test_lvm"
    "test_mbr"
    "test_md_raid0_zones"
    "test_md_raid1_multiple_disks"
    "test_md_read"
    "test_vinum"
  ];

  meta = with lib; {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    homepage = "https://github.com/fox-it/dissect.volume";
    changelog = "https://github.com/fox-it/dissect.volume/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
