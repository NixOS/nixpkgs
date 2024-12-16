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
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimastbk";
    repo = "python-calamine";
    rev = "refs/tags/v${version}";
    hash = "sha256-zZqhvfpkkbWLhPJIthDgxqvPUMpaXkyptuzY2fcecHU=";
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
