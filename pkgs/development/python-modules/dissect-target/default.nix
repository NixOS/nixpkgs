{ lib
, stdenv
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
, dissect-shellitem
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
  version = "3.12";
  format = "pyproject";

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.target";
    rev = "refs/tags/${version}";
    hash = "sha256-ByjeQcoDi0edum2XebF2DQ7d0xeH2nyulj6vt7bztKg=";
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
      dissect-shellitem
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
    # Tests compare dates and times
    "yum"
    # Filesystem access, windows defender tests
    "test_defender_quarantine_recovery"
  ] ++
  # test is broken on Darwin
  lib.optional stdenv.hostPlatform.isDarwin "test_fs_attrs_no_os_listxattr";

  disabledTestPaths = [
    # Tests are using Windows paths
    "tests/test_plugins_browsers.py"
  ];

  meta = with lib; {
    description = "Dissect module that provides a programming API and command line tools";
    homepage = "https://github.com/fox-it/dissect.target";
    changelog = "https://github.com/fox-it/dissect.target/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
