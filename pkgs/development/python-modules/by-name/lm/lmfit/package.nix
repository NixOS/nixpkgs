{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  asteval,
  dill,
  numpy,
  scipy,
  uncertainties,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  matplotlib,
  pandas,
}:

buildPythonPackage rec {
  pname = "lmfit";
  version = "1.3.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PCLCjEP3F/bFtKO9geiTohSXOcJqWSwEby4zwjz75Jc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asteval
    dill
    numpy
    scipy
    uncertainties
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    matplotlib
    pandas
  ];

  pythonImportsCheck = [ "lmfit" ];

  disabledTests = [ "test_check_ast_errors" ];

  meta = {
    description = "Least-Squares Minimization with Bounds and Constraints";
    homepage = "https://lmfit.github.io/lmfit-py/";
    changelog = "https://github.com/lmfit/lmfit-py/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
