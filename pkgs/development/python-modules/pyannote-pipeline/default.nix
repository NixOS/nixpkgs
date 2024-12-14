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
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-pipeline";
    rev = "refs/tags/${version}";
    hash = "sha256-0wSgy6kbKi9Wa5dimOz34IV5/8fSwaHDMUpaBW7tm2Y=";
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
