{
  lib,
  fetchPypi,
  buildPythonPackage,
  numpy,
  scikit-learn,
  scipy,
  pybind11,
  setuptools,
  setuptools-scm,
  cython,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hmmlearn";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HTxdxMUlfgwjjcH+U4dwC4y5h+q4CO2z4Mc4KfHMROw=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
    pybind11
  ];

  dependencies = [
    numpy
    scikit-learn
    scipy
  ];

  postPatch = ''
    substituteInPlace src/hmmlearn/utils.py \
      --replace-fail \
        'a_sum.shape = shape' \
        'a_sum = np.reshape(a_sum, shape, copy=False)'
  '';

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
})
