{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libiconv,
  cargo,
  rustPlatform,
  rustc,
  objsize,
  pydantic,
  pytestCheckHook,
  y-py,
}:

buildPythonPackage rec {
  pname = "pycrdt";
  version = "0.8.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt";
    rev = "refs/tags/v${version}";
    hash = "sha256-3j5OhjeVE42n4EEOOMUGlQGdnQ/xia0KD543uCMFpCo=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "pycrdt" ];

  nativeCheckInputs = [
    objsize
    pydantic
    pytestCheckHook
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
