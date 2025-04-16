{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,

  # build-system
  setuptools,

  # dependencies
  astropy,
  ducc0,
  h5py,
  jax,
  jaxlib,
  matplotlib,
  mpi,
  mpi4py,
  numpy,
  scipy,

  # test
  pytestCheckHook,
  pytest-xdist,
  mpiCheckPhaseHook,
  openssh,
}:

buildPythonPackage rec {
  pname = "nifty8";
  version = "8.5.7";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "ift";
    repo = "nifty";
    tag = "v${version}";
    hash = "sha256-5KPmM1UaXnS/ZEsnyFyxvDk4Nc4m6AT5FDgmCG6U6YU=";
  };

  # nifty8.re is the jax-backed version of nifty8 (the regular one uses numpy).
  # It is not compatible with the latest jax update:
  # https://gitlab.mpcdf.mpg.de/ift/nifty/-/issues/414
  # While the issue is being fixed by upstream, we completely remove this package from the source and the tests.
  postPatch = ''
    rm -r src/re
    rm -r test/test_re
  '';

  build-system = [ setuptools ];

  dependencies = [
    astropy
    ducc0
    h5py
    jax
    jaxlib
    matplotlib
    mpi4py
    mpi
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    mpiCheckPhaseHook
    openssh
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # matplotlib/backend_bases.py", line 2654 in create_with_canvas
    "test_optimize_kl_domain_expansion"
    "test_plot_priorsamples"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # matplotlib/backend_bases.py", line 2654 in create_with_canvas
    "test/test_plot.py"
  ];

  __darwinAllowLocalNetworking = true;
  postCheck =
    lib.optionalString
      (
        # Fails on aarch64-linux with:
        # hwloc/linux: failed to find sysfs cpu topology directory, aborting linux discovery.
        # All nodes which are allocated for this job are already filled.
        !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64)
      )
      ''
        ${lib.getExe' mpi "mpirun"} -n 2 --bind-to none python3 -m pytest test/test_mpi
      '';

  pythonImportsCheck = [ "nifty8" ];

  meta = {
    homepage = "https://gitlab.mpcdf.mpg.de/ift/nifty";
    changelog = "https://gitlab.mpcdf.mpg.de/ift/nifty/-/blob/v${version}/ChangeLog.md";
    description = "Bayesian Imaging library for high-dimensional posteriors";
    longDescription = ''
      NIFTy, "Numerical Information Field Theory", is a Bayesian imaging library.
      It is designed to infer the million to billion dimensional posterior
      distribution in the image space from noisy input data.  At the core of
      NIFTy lies a set of powerful Gaussian Process (GP) models and accurate
      Variational Inference (VI) algorithms.
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ parras ];
  };
}
