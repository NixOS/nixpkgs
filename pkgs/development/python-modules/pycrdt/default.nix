{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, libiconv
, cargo
, rustPlatform
, rustc
, pydantic
, pytestCheckHook
, y-py
}:

buildPythonPackage rec {
  pname = "pycrdt";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt";
    rev = "refs/tags/v${version}";
    hash = "sha256-dNNFrCuNdkgUb/jgeAs3TPoB+m2Hym3+ze/X2ejXtW8=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  pythonImportsCheck = [ "pycrdt" ];

  # requires pydantic>=2.5
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    y-py
    pydantic
  ];

  meta = with lib; {
    description = "CRDTs based on Yrs";
    homepage = "https://github.com/jupyter-server/pycrdt";
    changelog = "https://github.com/jupyter-server/pycrdt/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = teams.jupyter.members;
  };
}
