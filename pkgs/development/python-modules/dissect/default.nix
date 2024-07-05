{
  lib,
  buildPythonPackage,
  dissect-archive,
  dissect-btrfs,
  dissect-cim,
  dissect-clfs,
  dissect-cobaltstrike,
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
  pythonRelaxDepsHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect";
  version = "3.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect";
    rev = "refs/tags/${version}";
    hash = "sha256-wHLpysvOkJ1t0KKJXwfeRp/7mSom5WvrJ0lyRGoDwJM=";
  };

  pythonRelaxDeps = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    dissect-archive
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

  pythonImportsCheck = [ "dissect" ];

  meta = with lib; {
    description = "Dissect meta module";
    homepage = "https://github.com/fox-it/dissect";
    changelog = "https://github.com/fox-it/dissect/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
