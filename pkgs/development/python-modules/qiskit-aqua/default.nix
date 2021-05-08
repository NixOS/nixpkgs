{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, cvxpy
, dlx
, docplex
, fastdtw
, h5py
, networkx
, numpy
, psutil
, python
, qiskit-ignis
, qiskit-terra
, quandl
, scikitlearn
, yfinance
  # Optional inputs
, withTorch ? false
, pytorch
, withPyscf ? false
, pyscf ? null
, withScikitQuant ? false
, scikit-quant ? null
, withCplex ? false
, cplex ? null
  # Check Inputs
, ddt
, pytestCheckHook
, pytest-timeout
, qiskit-aer
}:

buildPythonPackage rec {
  pname = "qiskit-aqua";
  version = "0.9.0";

  disabled = pythonOlder "3.6";

  # Pypi's tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit-aqua";
    rev = version;
    hash = "sha256-knue9uJih72UQHsvfXZ9AA94mol4ERa9Lo/GMcp+2hA=";
  };

  # Optional packages: pyscf (see below NOTE) & pytorch. Can install via pip/nix if needed.
  propagatedBuildInputs = [
    cvxpy
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
    yfinance
  ] ++ lib.optionals (withTorch) [ pytorch ]
  ++ lib.optionals (withPyscf) [ pyscf ]
  ++ lib.optionals (withScikitQuant) [ scikit-quant ]
  ++ lib.optionals (withCplex) [ cplex ];

  # *** NOTE ***
  # We make pyscf optional in this package, due to difficulties packaging it in Nix (test failures, complicated flags, etc).
  # See nixpkgs#78772, nixpkgs#83447. You are welcome to try to package it yourself,
  # or use the Nix User Repository version (https://github.com/drewrisinger/nur-packages).
  # It can also be installed at runtime from the pip wheel.
  # We disable appropriate tests below to allow building without pyscf installed

  postPatch = ''
    # Because this is a legacy/final release, the maintainers restricted the maximum
    # versions of all dependencies to the latest current version. That will not
    # work with nixpkgs' rolling release/update system.
    # Unlock all versions for compatibility
    substituteInPlace setup.py --replace "<=" ">="
    sed -i 's/\(\w\+-*\w*\).*/\1/' requirements.txt
    substituteInPlace requirements.txt --replace "dataclasses" ""

    # Add ImportWarning when running qiskit.chemistry (pyscf is a chemistry package) that pyscf is not included
    echo -e "\nimport warnings\ntry: import pyscf;\nexcept ImportError:\n    " \
      "warnings.warn('pyscf is not supported on Nixpkgs so some qiskit features will fail." \
        "You must install it yourself via pip or add it to your environment from the Nix User Repository." \
        "See https://github.com/NixOS/nixpkgs/pull/83447 for details', ImportWarning)\n" \
      >> qiskit/chemistry/__init__.py

    # Add ImportWarning when running qiskit.optimization that cplex (optimization package) is not included
    echo -e "\nimport warnings\ntry: import cplex;\nexcept ImportError:\n    " \
      "warnings.warn('cplex is not supported on Nixpkgs so some qiskit features will fail." \
        "You must install it yourself via pip or add it to your environment from the Nix User Repository." \
        "', ImportWarning)\n" \
      >> qiskit/optimization/__init__.py
  '';

  postInstall = "rm -rf $out/${python.sitePackages}/docs";  # Remove docs dir b/c it can cause conflicts.

  checkInputs = [
    pytestCheckHook
    ddt
    pytest-timeout
    qiskit-aer
  ];
  pythonImportsCheck = [
    "qiskit.aqua"
    "qiskit.aqua.algorithms"
    "qiskit.chemistry"
    "qiskit.finance"
    "qiskit.ml"
    "qiskit.optimization"
  ];
  pytestFlagsArray = [
    "--timeout=30"
    "--durations=10"
  ] ++ lib.optionals (!withPyscf) [
    "--ignore=test/chemistry/test_qeom_ee.py"
    "--ignore=test/chemistry/test_qeom_vqe.py"
    "--ignore=test/chemistry/test_vqe_uccsd_adapt.py"
    "--ignore=test/chemistry/test_bopes_sampler.py"
  ];
  disabledTests = [
    # Disabled due to missing pyscf
    "test_validate" # test/chemistry/test_inputparser.py

    # Online tests
    "test_exchangedata"
    "test_yahoo"

    # Disabling slow tests > 10 seconds
    "TestVQE"
    "TestOOVQE"
    "TestVQC"
    "TestQSVM"
    "TestOptimizerAQGD"
    "test_graph_partition_vqe"
    "TestLookupRotation"
    "_vqe"
    "TestHHL"
    "TestQGAN"
    "test_evaluate_qasm_mode"
    "test_measurement_error_mitigation_auto_refresh"
    "test_wikipedia"
    "test_shor_factoring_1__15___qasm_simulator____3__5__"
    "test_readme_sample"
    "test_ecev"
    "test_expected_value"
    "test_qubo_gas_int_paper_example"
    "test_shor_no_factors_1_5"
    "test_shor_no_factors_2_7"
    "test_evolve_2___suzuki___1__3_"
    "test_delta"
    "test_swaprz"
    "test_deprecated_algo_result"
    "test_unsorted_grouping"
    "test_ad_hoc_data"
    "test_nft"
    "test_oh"
    "test_confidence_intervals_00001"
    "test_eoh"
    "test_qasm_5"
    "test_uccsd_hf"
  ];

  meta = with lib; {
    description = "An extensible library of quantum computing algorithms";
    homepage = "https://github.com/QISKit/qiskit-aqua";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
