{ lib
, stdenv
, buildPythonPackage
, pythonAtLeast
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
  version = "1.1.0";
  format = "setuptools";

  # Upstream package is broken on Python 3.11 https://github.com/quantumlib/Cirq/issues/6018
  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "refs/tags/v${version}";
    hash = "sha256-5j4hbG95KRfRQTyyZgoNp/eHIcy0FphyEhbYnzyUMO4=";
  };

  sourceRoot = "${src.name}/${pname}";

  patches = [
    # https://github.com/quantumlib/Cirq/pull/5991
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/python-cirq/cirq-pr5991-np1.24.patch?rev=8";
      stripLen = 1;
      hash = "sha256-d2FpaxM1PsPWT9ZM9v2gVrnLCy9zmvkkyAVgo85eL3U=";
    })
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "matplotlib~=3.0" "matplotlib" \
      --replace "networkx~=2.4" "networkx" \
      --replace "numpy>=1.16,<1.24" "numpy"
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    freezegun
  ];

  disabledTestPaths = lib.optionals (!withContribRequires) [
    # Requires external (unpackaged) libraries, so untested
    "cirq/contrib/"
    # No need to test the version number
    "cirq/_version_test.py"
  ];

  disabledTests = [
    # Tries to import flynt, which isn't in Nixpkgs
    "test_metadata_search_path"
    # Fails due pandas MultiIndex. Maybe issue with pandas version in nix?
    "test_benchmark_2q_xeb_fidelities"
    # https://github.com/quantumlib/Cirq/pull/5991
    "test_json_and_repr_data"
    # Tests for some changed error handling behavior in SymPy 1.12
    "test_custom_value_not_implemented"
  ];

  meta = with lib; {
    description = "Framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits";
    homepage = "https://github.com/quantumlib/cirq";
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger fab ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
