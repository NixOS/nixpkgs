{ lib
, buildPythonPackage
, dissect-cim
, dissect-clfs
, dissect-cobaltstrike
, dissect-cstruct
, dissect-esedb
, dissect-etl
, dissect-eventlog
, dissect-evidence
, dissect-extfs
, dissect-fat
, dissect-ffs
, dissect-executable
, dissect-hypervisor
, dissect-ntfs
, dissect-ole
, dissect-regf
, dissect-shellitem
, dissect-sql
, dissect-squashfs
, dissect-target
, dissect-util
, dissect-vmfs
, dissect-volume
, dissect-xfs
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect";
  version = "3.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.8.1";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect";
    rev = "refs/tags/${version}";
    hash = "sha256-WbKzmLeGsvzFA/bTTCqBEj/unbnzKQFzHFPRG411Cos=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cim
    dissect-clfs
    dissect-cobaltstrike
    dissect-cstruct
    dissect-esedb
    dissect-etl
    dissect-eventlog
    dissect-evidence
    dissect-executable
    dissect-extfs
    dissect-fat
    dissect-ffs
    dissect-hypervisor
    dissect-ntfs
    dissect-ole
    dissect-regf
    dissect-shellitem
    dissect-sql
    dissect-squashfs
    dissect-target
    dissect-util
    dissect-vmfs
    dissect-volume
    dissect-xfs
  ] ++ dissect-target.optional-dependencies.full;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dissect"
  ];

  meta = with lib; {
    description = "Dissect meta module";
    homepage = "https://github.com/fox-it/dissect";
    changelog = "https://github.com/fox-it/dissect/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
