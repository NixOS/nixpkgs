{
  lib,
  autograd,
  buildPythonPackage,
  fetchFromGitHub,
  cvxopt,
  cython,
  jax,
  jaxlib,
  matplotlib,
  numpy,
  pymanopt,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  scipy,
  setuptools,
  tensorflow,
  torch,
}:

buildPythonPackage rec {
  pname = "pot";
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PythonOT";
    repo = "POT";
    rev = "refs/tags/${version}";
    hash = "sha256-Yx9hjniXebn7ZZeqou0JEsn2Yf9hyJSu/acDlM4kCCI=";
  };

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [
    numpy
    scipy
  ];

  optional-dependencies = {
    backend-numpy = [ ];
    backend-jax = [
      jax
      jaxlib
    ];
    backend-cupy = [ ];
    backend-tf = [ tensorflow ];
    backend-torch = [ torch ];
    cvxopt = [ cvxopt ];
    dr = [
      scikit-learn
      pymanopt
      autograd
    ];
    gnn = [
      torch
      # torch-geometric
    ];
    plot = [ matplotlib ];
    all =
      with optional-dependencies;
      (
        backend-numpy
        ++ backend-jax
        ++ backend-cupy
        ++ backend-tf
        ++ backend-torch
        ++ optional-dependencies.cvxopt
        ++ dr
        ++ gnn
        ++ plot
      );
  };

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov-report= --cov=ot" "" \
      --replace " --durations=20" "" \
      --replace " --junit-xml=junit-results.xml" ""

    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0" "numpy"

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
