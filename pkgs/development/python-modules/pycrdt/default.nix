{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libiconv,
  rustPlatform,
  anyio,
  objsize,
  pydantic,
  pytestCheckHook,
  trio,
  y-py,
}:

buildPythonPackage rec {
  pname = "pycrdt";
  version = "0.8.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt";
    rev = "refs/tags/v${version}";
    hash = "sha256-fIpa4ikpeUVb8fucBfFS99zwWSK1GhGAC/QweXDc0Kg=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "pycrdt" ];

  nativeCheckInputs = [
    anyio
    objsize
    pydantic
    pytestCheckHook
    trio
    y-py
  ];

  meta = with lib; {
    description = "CRDTs based on Yrs";
    homepage = "https://github.com/jupyter-server/pycrdt";
    changelog = "https://github.com/jupyter-server/pycrdt/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = teams.jupyter.members;
  };
}
