{ lib
, asn1crypto
, buildPythonPackage
, defusedxml
, dissect-cim
, dissect-clfs
, dissect-cstruct
, dissect-esedb
, dissect-etl
, dissect-eventlog
, dissect-evidence
, dissect-extfs
, dissect-fat
, dissect-ffs
, dissect-hypervisor
, dissect-ntfs
, dissect-regf
, dissect-sql
, dissect-thumbcache
, dissect-util
, dissect-volume
, dissect-xfs
, fetchFromGitHub
, flow-record
, fusepy
, ipython
, pycryptodome
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, setuptools-scm
, structlog
, yara-python
, zstandard
}:

buildPythonPackage rec {
  pname = "dissect-target";
  version = "3.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.target";
    rev = "refs/tags/${version}";
    hash = "sha256-jFQ8BxCC4PW135igfXA5EmlWYIZ0zF12suiUMiLbArA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    defusedxml
    dissect-cstruct
    dissect-eventlog
    dissect-evidence
    dissect-hypervisor
    dissect-ntfs
    dissect-regf
    dissect-util
    dissect-volume
    flow-record
    structlog
  ];

  passthru.optional-dependencies = {
    full = [
      asn1crypto
      dissect-cim
      dissect-clfs
      dissect-esedb
      dissect-etl
      dissect-extfs
      dissect-fat
      dissect-ffs
      dissect-sql
      dissect-thumbcache
      dissect-xfs
      fusepy
      ipython
      pycryptodome
      pyyaml
      yara-python
      zstandard
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.full;

  pythonImportsCheck = [
    "dissect.target"
  ];

  disabledTests = [
    # Test requires rdump
    "test_exec_target_command"
    # Issue with tar file
    "test_tar_sensitive_drive_letter"
  ];

  meta = with lib; {
    description = "Dissect module that provides a programming API and command line tools";
    homepage = "https://github.com/fox-it/dissect.target";
    changelog = "https://github.com/fox-it/dissect.target/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
