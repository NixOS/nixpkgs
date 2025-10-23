{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  # build inputs
  inflect,
  num2words,
  numpy,
  scipy,
  scikit-learn,
  joblib,
  wikipedia,
  stemming,
  setuptools,
}:
let
  pname = "quantulum3";
  version = "0.9.2";
in
buildPythonPackage {
  inherit version pname;
  format = "pyproject";

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "quantulum3";
    rev = "9dafd76d3586aa5ea1b96164d86c73037e827294";
    hash = "sha256-fHztPeTbMp1aYsj+STYWzHgwdY0Q9078qXpXxtA8pPs=";
  };

  disabled = pythonOlder "3.7";

  propagatedBuildInputs = [
    inflect
    num2words
    numpy
    scipy
    scikit-learn
    joblib
    wikipedia
    stemming
    setuptools
  ];

  pythonImportsCheck = [ "quantulum3" ];

  meta = with lib; {
    description = "Library for unit extraction - fork of quantulum for python3";
    mainProgram = "quantulum3-training";
    homepage = "https://github.com/nielstron/quantulum3";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
