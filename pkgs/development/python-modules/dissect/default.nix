{ lib
, buildPythonPackage
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
, dissect-ole
, dissect-regf
, dissect-shellitem
, dissect-sql
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
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect";
    rev = version;
    hash = "sha256-DtiaBKQtz6CgU1csfGhCw0LJLoiKwyH6N6b7/elpJkU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cim
    dissect-clfs
    dissect-cstruct
    dissect-esedb
    dissect-etl
    dissect-eventlog
    dissect-evidence
    dissect-extfs
    dissect-fat
    dissect-ffs
    dissect-hypervisor
    dissect-ntfs
    dissect-ole
    dissect-regf
    dissect-shellitem
    dissect-sql
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
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
