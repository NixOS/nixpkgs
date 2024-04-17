{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pyannote-core
, pyannote-database
, pyyaml
, optuna
, tqdm
, docopt
, filelock
, scikit-learn
}:

buildPythonPackage rec {
  pname = "pyannote-pipeline";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-pipeline";
    rev = version;
    hash = "sha256-0wSgy6kbKi9Wa5dimOz34IV5/8fSwaHDMUpaBW7tm2Y=";
  };

  propagatedBuildInputs = [
    pyannote-core
    pyannote-database
    pyyaml
    optuna
    tqdm
    docopt
    filelock
    scikit-learn
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "pyannote.pipeline" ];

  meta = with lib; {
    description = "Tunable pipelines";
    mainProgram = "pyannote-pipeline";
    homepage = "https://github.com/pyannote/pyannote-pipeline";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
