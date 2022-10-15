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
, dissect-util
, dissect-volume
, dissect-xfs
, fetchFromGitHub
, flow-record
, fusepy
, ipython
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
  version = "3.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.target";
    rev = version;
    hash = "sha256-EWUYN2OsYeDo3C+QgjAVq9NXiVk1KWGILwtT0cI0tB0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
      defusedxml
      dissect-cim
      dissect-clfs
      dissect-esedb
      dissect-etl
      dissect-extfs
      dissect-fat
      dissect-ffs
      dissect-sql
      dissect-xfs
      fusepy
      ipython
      pyyaml
      yara-python
      zstandard
    ];
  };

  checkInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.full;

  pythonImportsCheck = [
    "dissect.target"
  ];

  disabledTests = [
    # Test requires rdump
    "test_exec_target_command"
  ];

  meta = with lib; {
    description = "Dissect module that provides a programming API and command line tools";
    homepage = "https://github.com/fox-it/dissect.target";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
