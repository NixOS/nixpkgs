{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, cmake
, openblas
, libcint
, libxc
, xcfun
, h5py
, numpy
, scipy
  # Check Inputs
, nose
, nose-exclude
}:

buildPythonPackage rec {
  pname = "pyscf";
  version = "1.7.1";

  # must download from GitHub to get the Cmake & C source files
  src = fetchFromGitHub {
    owner = "pyscf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fciw9id8fr9396sz52ap5gys0i9hmrmrwm0i1k1k7aciqab3kls";
  };

  disabled = isPy27;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcint
    libxc
    openblas
    xcfun
  ];

  prePatch = ''
    mkdir -p ./pyscf/lib/deps/include ./pyscf/lib/deps/lib
    ln -s ${lib.strings.makeSearchPath "include" [xcfun] }/xc.h ./pyscf/lib/deps/include/xcfun.h
    ln -s ${lib.strings.makeLibraryPath [ xcfun ] }/libxc.so ./pyscf/lib/deps/lib/libxcfun.so
  '';


  cmakeFlags = [
    # disable rebuilding/downloading the required libraries
    "-DBUILD_LIBCINT=0"
    "-DBUILD_LIBXC=0"
    "-DBUILD_XCFUN=0"
    "-DENABLE_XCFUN=1"
  ];
  # Configure CMake to build C files in pyscf/lib
  preConfigure = ''
    pushd pyscf/lib
  '';
  postConfigure = ''
    popd
  '';

  # Build C dependencies
  preBuild = ''
    pushd pyscf/lib/build
    export LD_LIBRARY_PATH=$(pwd)/lib/deps/include:$LD_LIBRARY_PATH
    make
    popd
  '';

  propagatedBuildInputs = [
    h5py
    numpy
    scipy
  ];

  PYSCF_INC_DIR = lib.strings.makeLibraryPath [ libcint libxc ] + ":" + lib.strings.makeSearchPath "include" [ xcfun ];

  pythonImportsCheck = [ "pyscf" ];

  checkInputs = [ nose nose-exclude ];
  # from source/.travis.yml, mostly
  # Tests take about 30 mins to run
  preCheck = ''
    # HACK: Move compiled libraries to test dir so pyscf import mechanism can find them
    cp ./dist/tmpbuild/pyscf/pyscf/lib/*.so ./pyscf/lib/

    # Set config used by tests to ensure reproducibility
    echo 'pbc_tools_pbc_fft_engine = "NUMPY"' > pyscf/pyscf_config.py
    export OMP_NUM_THREADS=1
    export PYSCF_CONFIG_FILE=$(pwd)/pyscf/pyscf_config.py
  '';
  checkPhase = ''
    runHook preCheck

    nosetests -v \
      --where=pyscf \
      --detailed-errors \
      --exclude-dir=geomopt \
      --exclude-dir=dmrgscf \
      --exclude-dir=fciqmcscf \
      --exclude-dir=icmpspt \
      --exclude-dir=shciscf \
      --exclude-dir=nao \
      --exclude-dir=cornell_shci \
      --exclude-dir=xianci \
      --exclude=test_bz \
      --exclude=h2o_vdz \
      --exclude=test_mc2step_4o4e \
      --exclude=test_ks_noimport \
      --exclude=test_jk_single_kpt \
      --exclude=test_jk_hermi0 \
      --exclude=test_j_kpts \
      --exclude=test_k_kpts \
      --exclude=high_cost \
      --exclude=skip \
      --exclude=call_in_background \
      --exclude=libxc_cam_beta_bug \
      --ignore-files=test_kuccsd_supercell_vs_kpts\.py \
      --ignore-files=test_kccsd_ghf\.py \
      --ignore-files=test_h_.*\.py \
      --ignore-files=test_P_uadc_ip\.py \
      --ignore-files=test_P_uadc_ea\.py \
      --exclude-test=pbc/gw/test/test_kgw_slow_supercell.DiamondTestSupercell3 \
      --exclude-test=pbc/gw/test/test_kgw_slow_supercell.DiamondKSTestSupercell3 \
      --exclude-test=pbc/gw/test/test_kgw_slow.DiamondTestSupercell3 \
      --exclude-test=pbc/gw/test/test_kgw_slow.DiamondKSTestSupercell3 \
      --exclude-test=pbc/tdscf/test/test_krhf_slow_supercell.DiamondTestSupercell3 \
      --exclude-test=pbc/tdscf/test/test_kproxy_hf.DiamondTestSupercell3 \
      --exclude-test=pbc/tdscf/test/test_kproxy_ks.DiamondTestSupercell3 \
      --exclude-test=pbc/tdscf/test/test_kproxy_supercell_hf.DiamondTestSupercell3 \
      --exclude-test=pbc/tdscf/test/test_kproxy_supercell_ks.DiamondTestSupercell3 \
      --ignore-files=.*_slow.*py \
      --ignore-files=.*_kproxy_.*py \
      --ignore-files=test_proxy\.py

      runHook postCheck
  '';

  # failed tests: test_rsh_df4c_get_jk

  meta = with lib; {
    description = "Python-based Simulations of Chemistry Framework";
    longDescription = ''
      PySCF is an open-source collection of electronic structure modules powered by Python.
      The package aims to provide a simple, lightweight, and efficient platform
      for quantum chemistry calculations and methodology development.
    '';
    homepage = "http://www.pyscf.org/";
    downloadPage = "https://github.com/pyscf/pyscf/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
