{ lib
, buildPythonPackage
, cmake
, cvxopt
, fetchPypi
, future
, numpy
, pytestCheckHook
, pythonOlder
, qdldl
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "0.6.2.post5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-svoXquQqftSY7CYbM/Jiu0s2BefoRkBiFZ2froF/DWE=";
  };

  postPatch = ''
    sed -i 's/sp.random/np.random/g' src/osqp/tests/*.py
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
    numpy
    qdldl
    scipy
  ];

  checkInputs = [
    cvxopt
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "osqp"
  ];

  disabledTests = [
    # Test are failing due to scipy update (removal of scipy.random in 1.9.0)
    # Is fixed upstream but requires a new release
    "test_feasibility_problem"
    "test_issue14"
    "test_polish_random"
    "test_polish_unconstrained"
    "test_primal_and_dual_infeasible_problem"
    "test_primal_infeasible_problem"
    "test_solve"
    "test_unconstrained_problem"
    "test_update_A_allind"
    "test_update_A"
    "test_update_bounds"
    "test_update_l"
    "test_update_P_A_allind"
    "test_update_P_A_indA"
    "test_update_P_A_indP_indA"
    "test_update_P_A_indP"
    "test_update_P_allind"
    "test_update_P"
    "test_update_q"
    "test_update_u"
    "test_warm_start"
  ];

  meta = with lib; {
    description = "The Operator Splitting QP Solver";
    longDescription = ''
      Numerical optimization package for solving problems in the form
        minimize        0.5 x' P x + q' x
        subject to      l <= A x <= u

      where x in R^n is the optimization variable
    '';
    homepage = "https://osqp.org/";
    downloadPage = "https://github.com/oxfordcontrol/osqp-python/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
