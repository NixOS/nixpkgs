{ lib
, stdenv
, buildPythonPackage
, cvxopt
, ecos
, fetchPypi
, numpy
, osqp
, pytestCheckHook
, pythonOlder
, scipy
, scs
, setuptools
, useOpenmp ? (!stdenv.isDarwin)
}:

buildPythonPackage rec {
  pname = "cvxpy";
  version = "1.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Hv+k2d6dVqFVMT9piLvAeIkes6Zs6eBB6qQcODQo8s=";
  };

  propagatedBuildInputs = [
    cvxopt
    ecos
    numpy
    osqp
    scipy
    scs
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Required flags from https://github.com/cvxpy/cvxpy/releases/tag/v1.1.11
  preBuild = lib.optionalString useOpenmp ''
    export CFLAGS="-fopenmp"
    export LDFLAGS="-lgomp"
  '';

  pytestFlagsArray = [
    "cvxpy"
  ];

  disabledTests = [
   # Disable the slowest benchmarking tests, cuts test time in half
    "test_tv_inpainting"
    "test_diffcp_sdp_example"
    "test_huber"
    "test_partial_problem"
  ] ++ lib.optionals stdenv.isAarch64 [
    "test_ecos_bb_mi_lp_2" # https://github.com/cvxpy/cvxpy/issues/1241#issuecomment-780912155
  ];

  pythonImportsCheck = [
    "cvxpy"
  ];

  meta = with lib; {
    description = "A domain-specific language for modeling convex optimization problems in Python";
    homepage = "https://www.cvxpy.org/";
    downloadPage = "https://github.com/cvxpy/cvxpy//releases";
    changelog = "https://github.com/cvxpy/cvxpy/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
