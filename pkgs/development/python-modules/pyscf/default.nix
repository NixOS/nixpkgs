{ buildPythonPackage
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, blas
, libcint
, libxc
, xcfun
, cppe
, h5py
, numpy
, scipy
, nose
, nose-exclude
}:

buildPythonPackage rec {
  pname = "pyscf";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "pyscf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KMxwyAK00Zc0i76zWTMznfXQCVCt+4HOH8SlwuOCORk=";
  };

  patches = [ (fetchpatch {
    name = "libxc-6";  # https://github.com/pyscf/pyscf/pull/1467
    url = "https://github.com/pyscf/pyscf/commit/ebcfacc90e119cd7f9dcdbf0076a84660349fc79.patch";
    sha256 = "sha256-O+eDlUKJeThxQcHrMGqxjDfRCmCNP+OCgv/L72jAF/o=";
  })];

  # setup.py calls Cmake and passes the arguments in CMAKE_CONFIGURE_ARGS to cmake.
  nativeBuildInputs = [ cmake ];
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

  propagatedBuildInputs = [
    cppe
    h5py
    numpy
    scipy
  ];

  checkInputs = [ nose nose-exclude ];

  pythonImportsCheck = [ "pyscf" ];
  preCheck = ''
    # Set config used by tests to ensure reproducibility
    echo 'pbc_tools_pbc_fft_engine = "NUMPY"' > pyscf/pyscf_config.py
    export OMP_NUM_THREADS=1
    ulimit -s 20000
    export PYSCF_CONFIG_FILE=$(pwd)/pyscf/pyscf_config.py
  '';
  # As defined for the PySCF CI at https://github.com/pyscf/pyscf/blob/master/.github/workflows/run_tests.sh
  # minus some additionally numerically instable tests, that are sensitive to BLAS, FFTW, etc.
  checkPhase = ''
    runHook preCheck

    nosetests pyscf/ -v \
      --exclude-dir=examples --exclude-dir=pyscf/pbc/grad \
      --exclude-dir=pyscf/x2c \
      --exclude-dir=pyscf/adc \
      --exclude-dir=pyscf/pbc/tdscf \
      -e test_bz \
      -e h2o_vdz \
      -e test_mc2step_4o4e \
      -e test_ks_noimport \
      -e test_jk_hermi0 \
      -e test_j_kpts \
      -e test_k_kpts \
      -e test_lda \
      -e high_cost \
      -e skip \
      -e call_in_background \
      -e libxc_cam_beta_bug \
      -e test_finite_diff_rks_eph \
      -e test_finite_diff_uks_eph \
      -e test_pipek \
      -e test_n3_cis_ewald \
      -I test_kuccsd_supercell_vs_kpts\.py \
      -I test_kccsd_ghf\.py \
      -I test_h_.*\.py \
      --exclude-test=pyscf/pbc/gw/test/test_kgw_slow_supercell.DiamondTestSupercell3 \
      --exclude-test=pyscf/pbc/gw/test/test_kgw_slow_supercell.DiamondKSTestSupercell3 \
      --exclude-test=pyscf/pbc/gw/test/test_kgw_slow.DiamondTestSupercell3 \
      --exclude-test=pyscf/pbc/gw/test/test_kgw_slow.DiamondKSTestSupercell3 \
      --exclude-test=pyscf/pbc/tdscf/test/test_krhf_slow_supercell.DiamondTestSupercell3 \
      --exclude-test=pyscf/pbc/tdscf/test/test_kproxy_hf.DiamondTestSupercell3 \
      --exclude-test=pyscf/pbc/tdscf/test/test_kproxy_ks.DiamondTestSupercell3 \
      --exclude-test=pyscf/pbc/tdscf/test/test_kproxy_supercell_hf.DiamondTestSupercell3 \
      --exclude-test=pyscf/pbc/tdscf/test/test_kproxy_supercell_ks.DiamondTestSupercell3 \
      -I .*_slow.*py -I .*_kproxy_.*py -I test_proxy.py tdscf/*_slow.py gw/*_slow.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Python-based simulations of chemistry framework";
    homepage = "https://github.com/pyscf/pyscf";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.sheepforce ];
  };
}
