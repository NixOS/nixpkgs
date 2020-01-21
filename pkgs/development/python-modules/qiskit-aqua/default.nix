{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, cvxopt
, dlx
, docplex
, fastdtw
, h5py
, networkx
, numpy
, psutil
, qiskit-ignis
, qiskit-terra
, quandl
, scikitlearn
  # Check Inputs
, parameterized
, pytestCheckHook
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-aqua";
  version = "0.6.5";

  disabled = pythonOlder "3.5";

  # Pypi's tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aqua";
    rev = version;
    sha256 = "03c0gl2qxyngf3cccjghjb0bhp0w78sdbvhim08cimf3cd577ldz";
  };

  # Optional packages: pyscf (see below NOTE) & pytorch. Can install via pip/nix if needed.
  propagatedBuildInputs = [
    cvxopt
    docplex
    dlx # Python Dancing Links package
    fastdtw
    h5py
    networkx
    numpy
    psutil
    qiskit-terra
    qiskit-ignis
    quandl
    scikitlearn
  ];

  # *** NOTE ***
  # We make pyscf optional in this package, due to difficulties packaging it in Nix (test failures, complicated flags, etc).
  # See nixpkgs#78772, nixpkgs#83447. You are welcome to try to package it yourself,
  # or use the Nix User Repository version (https://github.com/drewrisinger/nur-packages).
  # It can also be installed at runtime from the pip wheel.
  # We disable appropriate tests below to allow building without pyscf installed

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyscf; sys_platform == 'linux' or (python_version < '3.8' and sys_platform != 'win32')" ""

    # Add ImportWarning when running qiskit.chemistry (pyscf is a chemistry package) that pyscf is not included
    echo -e "\nimport warnings\ntry: import pyscf;\nexcept:\n    " \
      "warnings.warn('pyscf is not supported on Nixpkgs so some qiskit features will fail." \
        "You must install it yourself via pip or add it to your environment from the Nix User Repository." \
        "See https://github.com/NixOS/nixpkgs/pull/83447 for details', ImportWarning)\n" \
      >> qiskit/chemistry/__init__.py
  '';

  checkInputs = [ parameterized qiskit-aer pytestCheckHook ];
  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [
    "qiskit.aqua"
    "qiskit.aqua.algorithms"
    "qiskit.chemistry"
    "qiskit.finance"
    "qiskit.ml"
    "qiskit.optimization"
  ];
  pytestFlagsArray = [
    # Disabled b/c missing pyscf
    "--ignore=test/chemistry/test_qeom_ee.py"
    "--ignore=test/chemistry/test_qeom_vqe.py"
    "--ignore=test/chemistry/test_vqe_uccsd_adapt.py"

    # following tend to be slow tests, all pass
    "--ignore-glob=*vqc.py"
    "--ignore-glob=*hhl.py"
    "--ignore-glob=*qgan.py"
  ];
  disabledTests = [
    # Disabled due to missing pyscf
    "test_validate" # test/chemistry/test_inputparser.py

    # Disabling slow tests > 1 min
    "test_qsvm_multiclass_error_correcting_code"
    "test_vqe_qasm"
    "test_qgan_training"
    "test_qgan_training_run_algo_numpy"
    "test_shor_factoring_0"
    "test_lookup_rotation_4"
    "test_lookup_rotation_neg_4"
    "test_mcrz_11"
    "test_evolve_1_suzuki"
    "test_mct_with_dirty_ancillae_15"
    "test_vqc_with_raw_feature_vector_on_wine"
  ];

  meta = with lib; {
    description = "An extensible library of quantum computing algorithms";
    homepage = "https://github.com/QISKit/qiskit-aqua";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
