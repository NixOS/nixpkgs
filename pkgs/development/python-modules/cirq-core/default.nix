{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, matplotlib
, networkx
, numpy
, pandas
, requests
, scipy
, sortedcontainers
, sympy
, tqdm
, typing-extensions
  # Contrib requirements
, withContribRequires ? false
, autoray ? null
, opt-einsum
, ply
, pylatex ? null
, pyquil ? null
, quimb ? null
  # test inputs
, pytestCheckHook
, freezegun
, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "cirq-core";
  version = "0.11.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "v${version}";
    hash = "sha256-JaKTGnkYhzIFb35SGaho8DRupoT0JFYKA5+rJEq4oXw=";
  };

  sourceRoot = "source/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "matplotlib~=3.0" "matplotlib" \
      --replace "networkx~=2.4" "networkx" \
      --replace "numpy~=1.16" "numpy" \
      --replace "requests~=2.18" "requests"
  '';

  propagatedBuildInputs = [
    matplotlib
    networkx
    numpy
    pandas
    requests
    scipy
    sortedcontainers
    sympy
    tqdm
    typing-extensions
  ] ++ lib.optionals withContribRequires [
    autoray
    opt-einsum
    ply
    pylatex
    pyquil
    quimb
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    freezegun
  ];

  pytestFlagsArray = lib.optionals (!withContribRequires) [
    # requires external (unpackaged) libraries, so untested.
    "--ignore=cirq/contrib/"
  ];
  disabledTests = [
    "test_metadata_search_path" # tries to import flynt, which isn't in Nixpkgs
    "test_benchmark_2q_xeb_fidelities" # fails due pandas MultiIndex. Maybe issue with pandas version in nix?
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [
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
