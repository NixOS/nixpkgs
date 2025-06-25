{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  rustPlatform,

  # tests
  anyio,
  objsize,
  pydantic,
  pytestCheckHook,
  trio,
  y-py,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pycrdt";
  version = "0.12.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt";
    tag = version;
    hash = "sha256-1RTH6u+B+u4+ILvQufHgKCRW1Pj3Tyz5PFOBP/bDWD4=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ anyio ];

  pythonImportsCheck = [ "pycrdt" ];

  nativeCheckInputs = [
    anyio
    objsize
    pydantic
    pytestCheckHook
    trio
    y-py
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::pytest.PytestUnknownMarkWarning" # requires unpackaged pytest-mypy-testing
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "CRDTs based on Yrs";
    homepage = "https://github.com/jupyter-server/pycrdt";
    changelog = "https://github.com/jupyter-server/pycrdt/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.jupyter ];
  };
}
