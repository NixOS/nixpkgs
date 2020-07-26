{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, freezegun
, google_api_core
, matplotlib
, networkx
, numpy
, pandas
, protobuf
, requests
, scipy
, sortedcontainers
, sympy
, typing-extensions
  # test inputs
, pytestCheckHook
, pytest-asyncio
, pytest-benchmark
, ply
, pydot
, pyyaml
, pygraphviz
}:

buildPythonPackage rec {
  pname = "cirq";
  version = "0.8.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "v${version}";
    sha256 = "0xs46s19idh8smf80zhgraxwh3lphcdbljdrhxwhi5xcc41dfsmf";
  };

  patches = [
    (fetchpatch {
      # Fixes serialization issues on certain versions of protobuf & numpy.
      name = "cirq-pr-2986-protobuf-bools.patch";
      url = "https://github.com/quantumlib/Cirq/commit/78ddfb574c0f3936f713613bf4ba102163efb7b3.patch";
      sha256 = "0hmad9ndsqf5ci7shvd924d2rv4k9pzx2r2cl1bm5w91arzz9m18";
    })
  ];

  propagatedBuildInputs = [
    freezegun
    google_api_core
    numpy
    matplotlib
    networkx
    pandas
    protobuf
    requests
    scipy
    sortedcontainers
    sympy
    typing-extensions
  ];

  doCheck = true;
  # pythonImportsCheck = [ "cirq" "cirq.Ciruit" ];  # cirq's importlib hook doesn't work here
  dontUseSetuptoolsCheck = true;
  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-benchmark
    ply
    pydot
    pyyaml
    pygraphviz
  ];

  pytestFlagsArray = [
    "--ignore=dev_tools"  # Only needed when developing new code, which is out-of-scope
  ];
  disabledTests = [
    "test_serialize_sympy_constants"  # fails due to small error in pi (~10e-7)
    "test_convert_to_ion_gates" # fails due to rounding error, 0.75 != 0.750...2

    # Newly disabled tests on cirq 0.8
    # TODO: test & figure out why failing
    "engine_job_test"
    "test_health"
    "test_run_delegation"
  ] ++ lib.optionals stdenv.isAarch64 [
    # Seem to fail due to math issues on aarch64?
    "expectation_from_wavefunction"
    "test_single_qubit_op_to_framed_phase_form_output_on_example_case"
  ];

  meta = with lib; {
    description = "A framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits.";
    homepage = "https://github.com/quantumlib/cirq";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
