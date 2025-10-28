{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pandas,
  pyannote-core,
  pyannote-database,
  pythonOlder,
  scikit-learn,
  scipy,
  setuptools,
  sympy,
  tabulate,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pyannote-metrics";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-metrics";
    tag = version;
    hash = "sha256-tinNdFiUISnzUDnzM8wT3+0W8Dlc9gbCiNoIMo9xNKY=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    pyannote-core
    pyannote-database
    pandas
    scipy
    scikit-learn
    docopt
    tabulate
    matplotlib
    sympy
    numpy
  ];

  pythonImportsCheck = [ "pyannote.metrics" ];

  meta = with lib; {
    description = "Toolkit for reproducible evaluation, diagnostic, and error analysis of speaker diarization systems";
    homepage = "https://github.com/pyannote/pyannote-metrics";
    changelog = "http://pyannote.github.io/pyannote-metrics/changelog.html";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "pyannote-metrics";
  };
}
