{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  cmake,
  blas,
  libcint,
  libxc,
  xcfun,
  cppe,
  h5py,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyscf";
  version = "2.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyscf";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-y1RQKxFfhOC6+vUMJiXexaZeYZhav5t30XP7jooJ//0=";
  };

  # setup.py calls Cmake and passes the arguments in CMAKE_CONFIGURE_ARGS to cmake.
  build-system = [ cmake ];
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
    cppe
    h5py
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pyscf" ];
  preCheck = ''
    # Set config used by tests to ensure reproducibility
    echo 'pbc_tools_pbc_fft_engine = "NUMPY"' > pyscf/pyscf_config.py
    export OMP_NUM_THREADS=1
    ulimit -s 20000
    export PYSCF_CONFIG_FILE=$(pwd)/pyscf/pyscf_config.py
  '';

  # Numerically slightly off tests
  disabledTests = [
    "test_tdhf_singlet"
    "test_ab_hf"
    "test_ea"
    "test_bz"
    "h2o_vdz"
    "test_mc2step_4o4e"
    "test_ks_noimport"
    "test_jk_hermi0"
    "test_j_kpts"
    "test_k_kpts"
    "test_lda"
    "high_cost"
    "skip"
    "call_in_background"
    "libxc_cam_beta_bug"
    "test_finite_diff_rks_eph"
    "test_finite_diff_uks_eph"
    "test_finite_diff_roks_grad"
    "test_finite_diff_df_roks_grad"
    "test_frac_particles"
    "test_nosymm_sa4_newton"
    "test_pipek"
    "test_n3_cis_ewald"
    "test_veff"
    "test_collinear_kgks_gga"
    "test_libxc_gga_deriv4"
  ];

  pytestFlagsArray = [
    "--ignore=pyscf/pbc/tdscf"
    "--ignore=pyscf/pbc/gw"
    "--ignore-glob=*_slow.*py"
    "--ignore-glob=*_kproxy_.*py"
    "--ignore-glob=test_proxy.py"
  ];

  meta = with lib; {
    description = "Python-based simulations of chemistry framework";
    homepage = "https://github.com/pyscf/pyscf";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = [ maintainers.sheepforce ];
  };
}
