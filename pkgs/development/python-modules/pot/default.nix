{ lib
, autograd
, buildPythonPackage
, cupy
, cvxopt
, cython
, fetchPypi
, matplotlib
, numpy
, tensorflow
, pymanopt
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, enableDimensionalityReduction ? false
, enableGPU ? false
}:

buildPythonPackage rec {
  pname = "pot";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "POT";
    inherit version;
    hash = "sha256-gcJTJ6ABl/8Rwf5SIc8YGtHf/mFWRBUuLhFd3d9eWRs=";
  };

  nativeBuildInputs = [
    numpy
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ] ++ lib.optionals enableGPU [
    cupy
  ] ++ lib.optionals enableDimensionalityReduction [
    autograd
    pymanopt
  ];

  nativeCheckInputs = [
    cvxopt
    matplotlib
    numpy
    tensorflow
    scikit-learn
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov-report= --cov=ot" "" \
      --replace " --durations=20" "" \
      --replace " --junit-xml=junit-results.xml" ""
    substituteInPlace setup.py \
      --replace '"oldest-supported-numpy", ' ""

    # we don't need setup.py to find the macos sdk for us
    sed -i '/sdk_path/d' setup.py
  '';

  # To prevent importing of an incomplete package from the build directory
  # instead of nix store (`ot` is the top-level package name).
  preCheck = ''
    rm -r ot
  '';

  disabledTests = [
    # GPU tests are always skipped because of sandboxing
    "warnings"
    # Fixture is not available
    "test_conditional_gradient"
    "test_convert_between_backends"
    "test_emd_backends"
    "test_emd_emd2_types_devices"
    "test_emd1d_type_devices"
    "test_emd2_backends"
    "test_factored_ot_backends"
    "test_free_support_barycenter_backends"
    "test_func_backends"
    "test_generalized_conditional_gradient"
    "test_line_search_armijo"
    "test_loss_dual"
    "test_max_sliced_backend"
    "test_plan_dual"
    "test_random_backends"
    "test_sliced_backend"
    "test_to_numpy"
    "test_wasserstein_1d_type_devices"
    "test_wasserstein"
    "test_weak_ot_bakends"
    # TypeError: Only integers, slices...
    "test_emd1d_device_tf"
  ];

  disabledTestPaths = [
    # AttributeError: module pytest has no attribute skip_backend
    "test/test_bregman.py"
    "test/test_da.py"
    "test/test_utils.py"
    "test/test_gromov.py"
    "test/test_helpers.py"
    "test/test_unbalanced.py"
  ] ++ lib.optionals (!enableDimensionalityReduction) [
    "test/test_dr.py"
  ];

  pythonImportsCheck = [
    "ot"
    "ot.lp"
  ];

  meta = with lib; {
    description = "Python Optimal Transport Library";
    homepage = "https://pythonot.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}
