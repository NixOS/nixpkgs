{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, openblas
, libcint
, libxc
, h5py
, numpy
, scipy
  # Check Inputs
, nose
, nose-exclude
}:

buildPythonPackage rec {
  pname = "pyscf";
  version = "1.7.0";

  # must download from GitHub to get the Cmake & C source files
  src = fetchFromGitHub {
    owner = "pyscf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gdmc04nr699bq6gkw9isfzahj0k2gqhxnjg6gj9rybmglarkn15";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcint
    libxc
    openblas
  ];
  cmakeFlags = [
    # disable rebuilding/downloading the required libraries
    "-DBUILD_LIBCINT=0"
    "-DBUILD_LIBXC=0"
    "-DBUILD_XCFUN=0"
  ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    h5py
    numpy
    scipy
  ];

  # prePatch = ''
  #   # echo "recursive-include pyscf test" >> MANIFEST.in
  #   # substituteInPlace setup.py --replace "*test*" ""  # include tests in output
  #   # substituteInPlace pyscf/lib/misc.py --replace "_loaderpath = os.path.dirname(__file__)" "_loaderpath = os.path.dirname(__file__); print(_loaderpath)"
  # '';

  PYSCF_INC_DIR = lib.strings.makeLibraryPath [ libcint libxc ];

  pythonImportsCheck = [ "pyscf" ];
  checkInputs = [ nose nose-exclude ];
  # from source/.travis.yml, mostly
  # Tests take about 50 mins to run
  checkPhase = ''
    # substituteInPlace pyscf/lib/misc.py --replace "__file__" "param.__file__"
    cp ./dist/tmpbuild/pyscf/pyscf/lib/*.so ./pyscf/lib/  # HACK: Move compiled libraries to test dir so pyscf import mechanism can find them
    nosetests -vv -x \
      --where=pyscf \
      --no-path \
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
      --ignore-files=test_kuccsd_supercell_vs_kpts.py \
      --ignore-files=test_kccsd_ghf.py \
      --ignore-files=test_h_.*.py \
      --ignore-files=test_P_uadc_ip.py \
      --ignore-files=test_P_uadc_ea.py \
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
      --ignore-files=test_proxy.py
      # --collect-only
      # tdscf/*_slow.py gw/*_slow.py are not compatible with python3.[456] and old numpy

      # Unused flags, from testing
      # --nocapture \
      # --first-pkg-wins \
      # --traverse-namespace \
      # --exclude-dir=examples \
  '';
  # checkInputs = [ pytest ];
  # checkPhase = ''
  #   cd pyscf
  #   for directory in `find . -type d -mindepth 1 -maxdepth 1 | sort -z`
  #   do
  #     echo "Testing $directory"
  #     ( pytest $directory )
  #   done
  # '';

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
