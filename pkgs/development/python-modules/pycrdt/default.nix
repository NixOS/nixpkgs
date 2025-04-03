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
  version = "0.12.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt";
    tag = version;
    hash = "sha256-qeDhNr7ZQ0Sxmulye1u5Y2ETdAKYbmYWY0udUaAclpQ=";
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
