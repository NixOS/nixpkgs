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

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "freezegun~=0.3.15" "freezegun" \
      --replace "matplotlib~=3.0" "matplotlib" \
      --replace "networkx~=2.4" "networkx" \
      --replace "numpy~=1.16, < 1.19" "numpy" \
      --replace "protobuf~=3.12.0" "protobuf"
  '';

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
  # pythonImportsCheck = [ "cirq" "cirq.Circuit" ];  # cirq's importlib hook doesn't work here
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
    "--benchmark-disable" # Don't need to run benchmarks when packaging.
  ];
  disabledTests = [
    "test_convert_to_ion_gates" # fails on some systems due to rounding error, 0.75 != 0.750...2
  ] ++ lib.optionals stdenv.isAarch64 [
    # Seem to fail due to math issues on aarch64?
    "expectation_from_wavefunction"
    "test_single_qubit_op_to_framed_phase_form_output_on_example_case"
  ];

  meta = with lib; {
    description = "A framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits.";
    homepage = "https://github.com/quantumlib/cirq";
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
