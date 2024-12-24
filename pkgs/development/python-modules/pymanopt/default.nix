{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
  scipy,
  torch,
  autograd,
  matplotlib,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pymanopt";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = version;
    hash = "sha256-LOEulticgCWZBCf3qj5KFBHt0lMd4H85368IhG3DQ4g=";
  };

  preConfigure = ''
    substituteInPlace pyproject.toml --replace-fail "\"pip==22.3.1\"," ""
  '';

  build-system = [
    setuptools-scm
  ];
  dependencies = [
    numpy
    scipy
    torch
  ];
  nativeCheckInputs = [
    autograd
    matplotlib
    pytestCheckHook
  ];

  preCheck = ''
    substituteInPlace "tests/conftest.py" \
      --replace-fail "import tensorflow as tf" ""
    substituteInPlace "tests/conftest.py" \
      --replace-fail "tf.random.set_seed(seed)" ""
  '';

  disabledTestPaths = [
    "tests/test_examples.py"
    "tests/backends/test_tensorflow.py"
    "tests/backends/test_jax.py"
    "tests/test_problem.py"
  ];

  pythonImportsCheck = [ "pymanopt" ];

  meta = {
    description = "Python toolbox for optimization on Riemannian manifolds with support for automatic differentiation";
    homepage = "https://www.pymanopt.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
