{ lib
, buildPythonPackage
, dissect-btrfs
, dissect-cim
, dissect-clfs
, dissect-cobaltstrike
, dissect-cstruct
, dissect-esedb
, dissect-etl
, dissect-eventlog
, dissect-evidence
, dissect-executable
, dissect-extfs
, dissect-fat
, dissect-ffs
, dissect-hypervisor
, dissect-jffs
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
, pythonRelaxDepsHook
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect";
  version = "3.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect";
    rev = "refs/tags/${version}";
    hash = "sha256-hy5Yr/yR7CC7cp6pA1JP+GKazu+N4AwPqFKwb7zM+N8=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-btrfs
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
    dissect-jffs
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
