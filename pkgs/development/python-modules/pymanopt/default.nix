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
}:

buildPythonPackage rec {
  pname = "pymanopt";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pDFRYhswcuAHG9pcqvzXIy3Ivhxe5R5Ric7AFRh7MK4=";
  };

  propagatedBuildInputs = [
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
      --replace "import tensorflow as tf" ""
    substituteInPlace "tests/conftest.py" \
      --replace "tf.random.set_seed(seed)" ""
  '';

  disabledTestPaths = [
    "tests/test_examples.py"
    "tests/backends/test_tensorflow.py"
    "tests/test_problem.py"
  ];

  pythonImportsCheck = [ "pymanopt" ];

  meta = {
    description = "Python toolbox for optimization on Riemannian manifolds with support for automatic differentiation";
    homepage = "https://www.pymanopt.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
    broken = lib.versionAtLeast scipy.version "1.10.0";
  };
}
