{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, pyannote-core
, pyannote-database
, pandas
, scipy
, scikit-learn
, docopt
, tabulate
, matplotlib
, sympy
, numpy
}:

buildPythonPackage rec {
  pname = "pyannote-metrics";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyannote";
    repo = "pyannote-metrics";
    rev = version;
    hash = "sha256-V4qyaCaFsoikfFILm2sccf6m7lqJSDTdLxS1sr/LXAY=";
  };

  propagatedBuildInputs = [
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

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "pyannote.metrics" ];

  meta = with lib; {
    description = "A toolkit for reproducible evaluation, diagnostic, and error analysis of speaker diarization systems";
    mainProgram = "pyannote-metrics";
    homepage = "https://github.com/pyannote/pyannote-metrics";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
