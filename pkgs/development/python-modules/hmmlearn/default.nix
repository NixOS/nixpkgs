{
  lib,
  fetchPypi,
  buildPythonPackage,
  numpy,
  scikit-learn,
  pybind11,
  setuptools-scm,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hmmlearn";
  version = "0.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HTxdxMUlfgwjjcH+U4dwC4y5h+q4CO2z4Mc4KfHMROw=";
  };

  buildInputs = [
    setuptools-scm
    cython
    pybind11
  ];

  propagatedBuildInputs = [
    numpy
    scikit-learn
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hmmlearn" ];

  pytestFlags = [
    "--pyargs"
    "hmmlearn"
  ];

  meta = {
    description = "Hidden Markov Models in Python with scikit-learn like API";
    homepage = "https://github.com/hmmlearn/hmmlearn";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
