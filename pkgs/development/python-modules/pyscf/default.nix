{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-sysetm
  cmake,
  setuptools,

  # build inputs
  blas,
  libcint,
  libxc,
  xcfun,

  # dependencies
  h5py,
  numpy,
  scipy,

  # optional-dependencies
  cppe,

  # tests
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyscf";
  version = "2.14.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pyscf";
    repo = "pyscf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9FyiN5VrFpZ6Q4JFvNn1gVQJq4KQysiL5Sz5E+fSC5U=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cmake<4.0" "cmake"
  '';

  # setup.py calls Cmake and passes the arguments in CMAKE_CONFIGURE_ARGS to cmake.
  build-system = [
    setuptools
    cmake
  ];
  dontUseCmakeConfigure = true;

  preConfigure = ''
    export CMAKE_CONFIGURE_ARGS="-DBUILD_LIBCINT=0 -DBUILD_LIBXC=0 -DBUILD_XCFUN=0"
    PYSCF_INC_DIR="${libcint}:${libxc}:${xcfun}";
  '';

  buildInputs = [
    blas
    libcint
    libxc
    xcfun
  ];

  dependencies = [
    h5py
    numpy
    scipy
  ];

  optional-dependencies = {
    cppe = [ cppe ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.cppe;
  pythonImportsCheck = [ "pyscf" ];
  preCheck =
    # Set config used by tests to ensure reproducibility
    ''
      echo 'pbc_tools_pbc_fft_engine = "NUMPY"' > pyscf/pyscf_config.py
      ulimit -s 20000
      export PYSCF_CONFIG_FILE=$(pwd)/pyscf/pyscf_config.py
    '';

  disabledTests = [
    # Numerically slightly off tests
    "call_in_background"
    "h2o_vdz"
    "high_cost"
    "libxc_cam_beta_bug"
    "skip"
    "test_ab_hf"
    "test_bz"
    "test_collinear_kgks_gga"
    "test_ea"
    "test_ee_adc3"
    "test_finite_diff_df_roks_grad"
    "test_finite_diff_rks_eph"
    "test_finite_diff_roks_grad"
    "test_finite_diff_uks_eph"
    "test_frac_particles"
    "test_gwac_pade_frozen"
    "test_j_kpts"
    "test_jk_hermi0"
    "test_k_kpts"
    "test_ks_noimport"
    "test_lda"
    "test_libxc_gga_deriv4"
    "test_mc2step_4o4e"
    "test_n3_cis_ewald"
    "test_nosymm_sa4_newton"
    "test_pipek"
    "test_rdm_trace"
    "test_sacasscf_grad"
    "test_set_param_named"
    "test_sparse_dot"
    "test_tdhf_singlet"
    "test_veff"

    # Flaky when using pytest-xdist:
    #   NotImplementedError: Guess type not implemented
    "test_ee_adc2x_cis"
    #   AttributeError: 'UADCIP' object has no attribute 'f_ov'
    "test_ee_adc2x"
    #   BlockingIOError: [Errno 11] Unable to synchronously open file
    "test_khf_newton"
    "test_get_rho"
    "test_init_guess_from_chkfile"
    "test_kghf"
    #   TypeError: '>' not supported between instances of 'list' and 'int'
    "test_to_khf_with_chkfile"

  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Numerically slightly off tests
    "test_ee_adc2x"
    "test_vs_libxc_rks"
    "test_vs_libxc_uks"
    "test_xcfun_gga_deriv3"
  ];

  disabledTestPaths = [
    "pyscf/grad/test/test_casscf.py"
    "pyscf/nac/test/test_sacasscf.py"
    "pyscf/pbc/gw"
    "pyscf/pbc/tdscf"
  ];

  meta = {
    description = "Python-based simulations of chemistry framework";
    homepage = "https://github.com/pyscf/pyscf";
    changelog = "https://github.com/pyscf/pyscf/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
