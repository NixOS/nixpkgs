{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, scipy
, torch
, autograd
<<<<<<< HEAD
, matplotlib
, pytestCheckHook
=======
, nose2
, matplotlib
, tensorflow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pymanopt";
  version = "2.1.1";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nbSxqMmYWi71s74bbB9LAlPKEslTqG/j266cLfNHrwg=";
  };

  propagatedBuildInputs = [ numpy scipy torch ];
<<<<<<< HEAD
  nativeCheckInputs = [ autograd matplotlib pytestCheckHook ];

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

=======
  nativeCheckInputs = [ nose2 autograd matplotlib tensorflow ];

  checkPhase = ''
    runHook preCheck

    # upstream themselves seem unsure about the robustness of these
    # tests - see https://github.com/pymanopt/pymanopt/issues/219
    grep -lr 'test_second_order_function_approximation' tests/ | while read -r fn ; do
      substituteInPlace "$fn" \
        --replace \
          'test_second_order_function_approximation' \
          'dont_test_second_order_function_approximation'
    done

    nose2 tests -v

    runHook postCheck
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [ "pymanopt" ];

  meta = {
    description = "Python toolbox for optimization on Riemannian manifolds with support for automatic differentiation";
    homepage = "https://www.pymanopt.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
<<<<<<< HEAD
    broken = lib.versionAtLeast scipy.version "1.10.0";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
