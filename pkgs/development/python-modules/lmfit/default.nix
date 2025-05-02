{ lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  asteval,
  numpy,
  scipy,
  uncertainties,
  pytestCheckHook,
  pandas,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "lmfit";
  version = "1.3.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-foI668BSN8qA0z0mDO27peJhkMzsn69ZXmgUOQneDJM=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace "--cov=lmfit --cov-report html" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asteval
    numpy
    scipy
    uncertainties
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    matplotlib
  ];

  disabledTests = [
    # https://github.com/lmfit/lmfit-py/issues/878
    "test_emcee_multiprocessing"
    "test_explicit_independent_vars"
    "test_result_eval_custom_x"
  ];

  meta = with lib; {
    description = "Least-Squares Minimization with Bounds and Constraints";
    homepage = "https://lmfit-py.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nomeata ];
  };
}
