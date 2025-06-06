{
  lib,
  buildPythonPackage,
  asteval,
  dill,
  fetchPypi,
  matplotlib,
  numpy,
  pandas,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
  setuptools,
  uncertainties,
}:

buildPythonPackage rec {
  pname = "lmfit";
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-czIea4gfL2hiNXIaffwCr2uw8DCiXv62Zjj2KxxgU6E=";
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
    matplotlib
    pandas
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "lmfit" ];

  disabledTests = [ "test_check_ast_errors" ];

  meta = with lib; {
    description = "Least-Squares Minimization with Bounds and Constraints";
    homepage = "https://lmfit.github.io/lmfit-py/";
    changelog = "https://github.com/lmfit/lmfit-py/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nomeata ];
  };
}
