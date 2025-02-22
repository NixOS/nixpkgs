{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  attrs,
  duet,
  matplotlib,
  networkx,
  numpy,
  pandas,
  requests,
  scipy,
  sortedcontainers,
  sympy,
  tqdm,
  typing-extensions,
  autoray ? null,
  opt-einsum,
  ply,
  pylatex ? null,
  pyquil ? null,
  quimb ? null,

  # tests
  freezegun,
  pytest-asyncio,
  pytestCheckHook,

  withContribRequires ? false,
}:

buildPythonPackage rec {
  pname = "cirq-core";
  version = "1.4.1-unstable-2024-09-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "3fefe2984a1203c0bf647c1ea84f4882b05f8477";
    hash = "sha256-/WDKVxNJ8pewTLAFTyAZ/nnYcJSLubEJcn7qoJslZ3U=";
  };

  sourceRoot = "${src.name}/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "matplotlib~=3.0" "matplotlib"
  '';

  build-system = [ setuptools ];

  dependencies =
    [
      attrs
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
    ]
    ++ lib.optionals withContribRequires [
      autoray
      opt-einsum
      ply
      pylatex
      pyquil
      quimb
    ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals (!withContribRequires) [
    # Requires external (unpackaged) libraries, so untested
    "cirq/contrib/"
    # No need to test the version number
    "cirq/_version_test.py"
  ];

  disabledTests =
    [
      # Assertion error
      "test_parameterized_cphase"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # https://github.com/quantumlib/Cirq/issues/5924
      "test_prepare_two_qubit_state_using_sqrt_iswap"
    ];

  meta = {
    description = "Framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits";
    homepage = "https://github.com/quantumlib/cirq";
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      drewrisinger
      fab
    ];
  };
}
