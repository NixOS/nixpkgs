{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # buildInputs
  libiconv,

  # build-system
  cargo,
  poetry-core,
  rustc,

  # dependencies
  packaging,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-calamine";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimastbk";
    repo = "python-calamine";
    tag = "v${version}";
    hash = "sha256-XR8KzLMQDXy9nt0Z/FRBFaWdOp8RcIIpJjDf5f9h1BE=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pyo3-file-0.8.1" = "sha256-EqeXykP7CF8SU5LgT9+y/FDy79E/DAJT2fc1OrmlOZE=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = [ libiconv ];

  build-system = [
    cargo
    poetry-core
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "python_calamine" ];

  meta = {
    description = "Python binding for calamine";
    homepage = "https://github.com/dimastbk/python-calamine";
    changelog = "https://github.com/dimastbk/python-calamine/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "python-calamine";
  };
}
