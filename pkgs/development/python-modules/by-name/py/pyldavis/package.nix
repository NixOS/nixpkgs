{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  funcy,
  ipython,
  jinja2,
  joblib,
  numpy,
  pandas,
  scikit-learn,
  scipy,
}:

buildPythonPackage rec {
  pname = "pyLDAvis";
  version = "3.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bmabey";
    repo = "pyLDAvis";
    rev = version;
    sha256 = "sha256-WIQytds3PeU85l6ix2UUIwypjpM5rMZvQxiHx9BY91Y=";
  };

  propagatedBuildInputs = [
    funcy
    jinja2
    joblib
    ipython
    numpy
    pandas
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [
    "pyLDAvis"
    "pyLDAvis.gensim_models"
  ];

  meta = with lib; {
    homepage = "https://github.com/bmabey/pyLDAvis";
    description = "Python library for interactive topic model visualization";
    license = licenses.bsd3;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
  };
}
