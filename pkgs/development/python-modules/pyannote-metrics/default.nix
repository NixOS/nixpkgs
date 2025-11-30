{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  pandas,
  pyannote-core,
  pyannote-database,
  scikit-learn,
  scipy,
  # undeclared cli dependencies
  docopt,
  tabulate,

  # tests
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "pyannote-metrics";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-metrics";
    tag = version;
    hash = "sha256-Ga5oSRkVdeQkDnjFcFebdZnFljjyn/TrtV8Y6UJxT2c=";
  };

  postPatch = ''
    substituteInPlace src/pyannote/metrics/cli.py \
      --replace-fail \
        'version="Evaluation"' \
        'version="${version}"'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    pandas
    pyannote-core
    pyannote-database
    scikit-learn
    scipy
    # Imported in pyannote/metrics/cli.py
    docopt
    tabulate
  ];

  pythonImportsCheck = [ "pyannote.metrics" ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Toolkit for reproducible evaluation, diagnostic, and error analysis of speaker diarization systems";
    homepage = "https://github.com/pyannote/pyannote-metrics";
    changelog = "http://pyannote.github.io/pyannote-metrics/changelog.html";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pyannote-metrics";
  };
}
