{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, duet
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
  version = "0.13.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "v${version}";
    sha256 = "sha256-MVfJ8iEeW8gFvCNTqrWfYpNNYuDAufHgcjd7Nh3qp8U=";
  };

  sourceRoot = "source/${pname}";

  patches = [
    # present in upstream master - remove after 0.13.1
    (fetchpatch {
      name = "fix-test-tolerances.part-1.patch";
      url = "https://github.com/quantumlib/Cirq/commit/eb1d9031e55d3c8801ea44abbb6a4132b2fc5126.patch";
      sha256 = "0ka24v6dfxnap9p07ni32z9zccbmw0lbrp5mcknmpsl12hza98xm";
      stripLen = 1;
    })
    (fetchpatch {
      name = "fix-test-tolerances.part-2.patch";
      url = "https://github.com/quantumlib/Cirq/commit/a28d601b2bcfc393336375c53e5915fd16455395.patch";
      sha256 = "0k2dqsm4ydn6556d40kc8j04jgjn59z4wqqg1jn1r916a7yxw493";
      stripLen = 1;
    })
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "matplotlib~=3.0" "matplotlib" \
      --replace "networkx~=2.4" "networkx" \
      --replace "numpy~=1.16" "numpy"
  '';

  propagatedBuildInputs = [
    duet
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
  ];

  meta = with lib; {
    description = "Framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits";
    homepage = "https://github.com/quantumlib/cirq";
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger fab ];
  };
}
