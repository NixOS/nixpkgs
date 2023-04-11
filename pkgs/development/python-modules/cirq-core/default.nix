{ lib
, stdenv
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, pythonRelaxDepsHook
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
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "refs/tags/v${version}";
    hash = "sha256-KEei5PJ0ammsduZVmMh2vaW3f58DYI4BCrFCl/SjUoo=";
  };

  sourceRoot = "source/${pname}";

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [
    "matplotlib"
    "networkx"
    "numpy"
    "duet"
    "sortedcontainers"
  ];

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
