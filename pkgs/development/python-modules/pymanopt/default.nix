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
  version = "2.2.0-unstable-2024-07-10";
  pyproject = true;

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "2.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "1de3b6f47258820fdc072fceaeaa763b9fd263b0";
    hash = "sha256-j/fVeMgoLLBgRYFtSj2ZyNJb8iuWlnn2/YpBqUoCAFk=";
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
