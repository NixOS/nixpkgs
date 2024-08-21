{
  lib,
  buildPythonPackage,
  dissect-archive,
  dissect-btrfs,
  dissect-cim,
  dissect-clfs,
  dissect-cstruct,
  dissect-esedb,
  dissect-etl,
  dissect-eventlog,
  dissect-evidence,
  dissect-executable,
  dissect-extfs,
  dissect-fat,
  dissect-ffs,
  dissect-hypervisor,
  dissect-jffs,
  dissect-ntfs,
  dissect-ole,
  dissect-regf,
  dissect-shellitem,
  dissect-sql,
  dissect-squashfs,
  dissect-target,
  dissect-util,
  dissect-vmfs,
  dissect-volume,
  dissect-xfs,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect";
  version = "3.15";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect";
    rev = "refs/tags/${version}";
    hash = "sha256-9LRF5WBaxCaj2MEa2q90294seAU+89p5t5JBVa3vb5w=";
  };

  pythonRelaxDeps = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-archive
    dissect-btrfs
    dissect-cim
    dissect-clfs
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

  pythonImportsCheck = [ "dissect" ];

  meta = with lib; {
    description = "Dissect meta module";
    homepage = "https://github.com/fox-it/dissect";
    changelog = "https://github.com/fox-it/dissect/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
