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
  version = "0.10.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt";
    tag = version;
    hash = "sha256-5ukP2J9Mm7yRVXZ6x5VbArF5GDxQvRvOpKEwiySzPV8=";
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "CRDTs based on Yrs";
    homepage = "https://github.com/jupyter-server/pycrdt";
    changelog = "https://github.com/jupyter-server/pycrdt/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = lib.teams.jupyter.members;
  };
}
