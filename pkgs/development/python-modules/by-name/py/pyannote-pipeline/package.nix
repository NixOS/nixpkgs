{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  filelock,
  optuna,
  pyannote-core,
  pyannote-database,
  pyyaml,
  scikit-learn,
  setuptools,
  tqdm,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pyannote-pipeline";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-pipeline";
    tag = version;
    hash = "sha256-MMMwZMxu8viUt2DgCgymbz2vEMM9TT0ySKL2KPzAPLA=";
  };

  postPatch = ''
    # Remove vendorized versioeer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    pyannote-core
    pyannote-database
    pyyaml
    optuna
    tqdm
    docopt
    filelock
    scikit-learn
  ];

  pythonImportsCheck = [ "pyannote.pipeline" ];

  meta = with lib; {
    description = "Tunable pipelines";
    homepage = "https://github.com/pyannote/pyannote-pipeline";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "pyannote-pipeline";
  };
}
