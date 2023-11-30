{ lib
, autograd
, buildPythonPackage
, fetchFromGitHub
, cupy
, cvxopt
, cython
, oldest-supported-numpy
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
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PythonOT";
    repo = "POT";
    rev = version;
    hash = "sha256-D61/dqO16VvcQx4FG1beKR4y1OQHndwCizaugNaUe4g=";
  };

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
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

    # we don't need setup.py to find the macos sdk for us
    sed -i '/sdk_path/d' setup.py
  '';

  # need to run the tests with the built package next to the test directory
  preCheck = ''
    pushd build/lib.*
    ln -s -t . "$OLDPWD/test"
  '';

  postCheck = ''
    popd
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

  disabledTestPaths = lib.optionals (!enableDimensionalityReduction) [
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
