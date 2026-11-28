{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  setuptools,

  # dependencies
  astropy,
  corner,
  h5py,
  matplotlib,
  mpmath,
  multiprocess,
  numba,
  numpy,
  pyxdg,
  pyyaml,
  schwimmbad,
  scikit-image,
  scikit-learn,
  scipy,
  tqdm,

  # tests
  emcee,
  mock,
  pytest-xdist,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "lenstronomy";
  version = "1.14.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lenstronomy";
    repo = "lenstronomy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-99NQwHpjQnwDH1TRGAAzF5IDMbvGjlS8QEMuMshmk3U=";
  };

  patches = [
    # jampy and mgefit are unfree and non-redistributable: only import them when actually used
    ./lazy-import-jampy.patch

    # NumPy 2.5 compatibility: np.linalg.eig now always returns complex values.
    # Taken from upstream main: https://github.com/lenstronomy/lenstronomy/pull/882
    ./numpy-2.5-compat.patch
  ];

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    # Pinned to <1.18 upstream, but the test suite passes with scipy 1.18
    "scipy"
  ];
  pythonRemoveDeps = [
    # Only needed for the optional "jampy" kinematics backend and MGE fitting.
    # Both are unfree and non-redistributable.
    "jampy"
    "mgefit"
    # Python 2 backport
    "configparser"
  ];
  dependencies = [
    astropy
    corner
    h5py
    matplotlib
    mpmath
    multiprocess
    numba
    numpy
    pyxdg
    pyyaml
    schwimmbad
    scikit-image
    scikit-learn
    scipy
    # Imported by the PSO sampler, but missing from setup.py
    tqdm
  ];

  # The top-level `test` package gets installed alongside `lenstronomy`
  postInstall = ''
    rm -r $out/${python.sitePackages}/test
  '';

  pythonImportsCheck = [ "lenstronomy" ];

  nativeCheckInputs = [
    emcee
    mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Unpackaged optional dependencies:
    # - jampy and mgefit are unfree and non-redistributable
    # - coolest, slitronomy, colossus, cobaya, zeus-mcmc, jaxtronomy, dynesty, nautilus-sampler
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_interpolated_sersic"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_jam_settings_symmetry"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_kinematic_lens_profiles"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_kinematic_light_profile"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_multi_obs_dispersion"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_velocity_dispersion"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPI::test_velocity_dispersion_map_direct_convolved_against_jampy"
    "test/test_Analysis/test_kinematics_api.py::TestKinematicsAPIJAMPy"
    "test/test_Cosmo/test_nfw_param.py::TestNFWParam::test_against_colossus"
    "test/test_ImSim/test_image_model_pixelbased.py"
    "test/test_JAMPy"
    "test/test_Sampling/test_Samplers/test_cobaya_sampler.py"
    "test/test_Sampling/test_Samplers/test_dynesty_sampler.py"
    "test/test_Sampling/test_Samplers/test_nautilus_sampler.py"
    "test/test_Sampling/test_likelihood.py::TestLikelihood::test_pixelbased_modelling"
    "test/test_Sampling/test_parameters.py::TestParam::test_jax_flag"
    "test/test_Sampling/test_sampler.py::TestSampler::test_mcmc_zeus"
    "test/test_Util/test_COOLEST"
    "test/test_Util/test_package_util.py::test_short_and_laconic"
    "test/test_Workflow/test_fitting_sequence.py::TestFittingSequence::test_cobaya"
    "test/test_Workflow/test_fitting_sequence.py::TestFittingSequence::test_dynesty"
    "test/test_Workflow/test_fitting_sequence.py::TestFittingSequence::test_nautilus"
    "test/test_Workflow/test_fitting_sequence.py::TestFittingSequence::test_zeus"

    # Slow (> 45s each)
    "test/test_GalKin/test_galkin.py::TestGalkin::test_dispersion_map_grid_convolved"
    "test/test_LensModel/test_convergence_integrals.py::TestConvergenceIntegrals::test_pdpl"
    "test/test_LensModel/test_convergence_integrals.py::TestConvergenceIntegrals::test_potential_from_kappa"
    "test/test_LensModel/test_convergence_integrals.py::TestConvergenceIntegrals::test_tnfwc"

    # Stochastic fit, flaky
    "test/test_Workflow/test_tracer_model_fit.py::TestTracerModelFit::test_run_fit"
  ];

  meta = {
    description = "Multi-purpose gravitational lens modelling software package";
    homepage = "https://github.com/lenstronomy/lenstronomy";
    changelog = "https://github.com/lenstronomy/lenstronomy/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
