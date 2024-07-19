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
  version = "3.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-metrics";
    rev = "refs/tags/${version}";
    hash = "sha256-V4qyaCaFsoikfFILm2sccf6m7lqJSDTdLxS1sr/LXAY=";
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
    maintainers = with maintainers; [ ];
    mainProgram = "pyannote-metrics";
  };
}
