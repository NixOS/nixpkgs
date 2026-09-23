{
  lib,
  buildPythonPackage,
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
  version = "0.10.0";
in
buildPythonPackage {
  inherit version pname;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "quantulum3";
    tag = version;
    hash = "sha256-gE5JNUkIa+x/ottgXEf1WlieUG9mEcKjl3GSC2fWATY=";
  };

  dependencies = [
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

  meta = {
    description = "Library for unit extraction - fork of quantulum for python3";
    mainProgram = "quantulum3-training";
    homepage = "https://github.com/nielstron/quantulum3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
