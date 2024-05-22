{
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  lib,

  # pythonPackages
  pylint-plugin-utils,
}:

buildPythonPackage rec {
  pname = "pylint-celery";
  version = "0.3";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "05fhwraq12c2724pn4py1bjzy5rmsrb1x68zck73nlp5icba6yap";
  };

  propagatedBuildInputs = [ pylint-plugin-utils ];

  # Testing requires a very old version of pylint, incompatible with other dependencies
  doCheck = false;

  meta = with lib; {
    description = "A Pylint plugin to analyze Celery applications";
    homepage = "https://github.com/PyCQA/pylint-celery";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
