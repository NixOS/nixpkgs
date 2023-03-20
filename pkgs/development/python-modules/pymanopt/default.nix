{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, scipy
, torch
, autograd
, nose2
, matplotlib
, tensorflow
}:

buildPythonPackage rec {
  pname = "pymanopt";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nbSxqMmYWi71s74bbB9LAlPKEslTqG/j266cLfNHrwg=";
  };

  propagatedBuildInputs = [ numpy scipy torch ];
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

  pythonImportsCheck = [ "pymanopt" ];

  meta = {
    description = "Python toolbox for optimization on Riemannian manifolds with support for automatic differentiation";
    homepage = "https://www.pymanopt.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
}
