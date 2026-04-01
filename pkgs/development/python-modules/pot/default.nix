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
  pytest-cov-stub,
  scikit-learn,
  scipy,
  setuptools,
  tensorflow,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "pot";
  version = "0.9.7-unstable-2026-03-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PythonOT";
    repo = "POT";
    rev = "41a4d57e1ecc88d79e8ebfe825b32ba761132007";
    # tag = finalAttrs.version;
    hash = "sha256-xM6GEBXRo6rOjX276glNyF1EIX5eM/3RR+N9fsjTk+Q=";
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
      with finalAttrs.passthru.optional-dependencies;
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
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

  pythonImportsCheck = [
    "ot"
    "ot.lp"
  ];

  meta = {
    description = "Python Optimal Transport Library";
    homepage = "https://pythonot.github.io/";
    changelog = "https://github.com/PythonOT/POT/blob/${finalAttrs.version}/RELEASES.md";
    downloadPage = "https://github.com/PythonOT/POT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yl3dy ];
  };
})
