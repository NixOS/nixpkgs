{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  pycrdt,
  sqlite-anyio,

  # tests
  pytestCheckHook,

  # postInstall
  python,
}:

buildPythonPackage rec {
  pname = "pycrdt-store";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt-store";
    tag = version;
    hash = "sha256-BaU6UKgS9hyqPKt0tTZW46XJtZi+a2ACg5bi0VDiT40=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    anyio
    pycrdt
    sqlite-anyio
  ];

  # pycrdt-store installs to $out/${python.sitePackages}/pycrdt/store, but `pycrdt`' files are not present.
  # Hence, neither pythonImportsCheck nor pytestCheckPhase work in this derivation.
  doCheck = false;

  meta = {
    description = "Persistent storage for pycrdt";
    homepage = "https://github.com/y-crdt/pycrdt-store";
    changelog = "https://github.com/y-crdt/pycrdt-store/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
