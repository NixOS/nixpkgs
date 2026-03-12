{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  jaxtyping,
  linear-operator,
  mpmath,
  scikit-learn,
  scipy,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gpytorch";
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cornellius-gp";
    repo = "gpytorch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftiAY02K0EwVQZufk8xR+/21A+2ONWchuWPF3a5lRW0=";
  };

  # AttributeError: module 'numpy' has no attribute 'trapz'
  postPatch = ''
    substituteInPlace gpytorch/kernels/spectral_mixture_kernel.py \
      --replace-fail \
        "np.trapz(emp_spect, freq)" \
        "np.trapezoid(emp_spect, freq)"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    jaxtyping
    linear-operator
    mpmath
    scikit-learn
    scipy
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gpytorch" ];

  disabledTests = [
    # AssertionError on number of warnings emitted
    "test_deprecated_methods"
    # flaky numerical tests
    "test_classification_error"
    "test_matmul_matrix_broadcast"
    "test_optimization_optimal_error"
    # https://github.com/cornellius-gp/gpytorch/issues/2396
    "test_t_matmul_matrix"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Hang forever
    "test/examples/test_spectral_mixture_gp_regression.py"
    "test/kernels/test_spectral_mixture_kernel.py"
    "test/utils/test_nearest_neighbors.py"
    "test/variational/test_nearest_neighbor_variational_strategy.py"
  ];

  meta = {
    description = "Highly efficient and modular implementation of Gaussian Processes, with GPU acceleration";
    homepage = "https://gpytorch.ai";
    downloadPage = "https://github.com/cornellius-gp/gpytorch";
    changelog = "https://github.com/cornellius-gp/gpytorch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
