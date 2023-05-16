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
<<<<<<< HEAD
  version = "1.2.2";
=======
  version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-BEoFKhGmHaBXYnRQTBfrfigDtBEo4lgh6WYyIH8jyIw=";
=======
    hash = "sha256-AM71vRRb+BtzYwt4kmrySyTxgFQh5iEcpYVYiqfMQVs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
