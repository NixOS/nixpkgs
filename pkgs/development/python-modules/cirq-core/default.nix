{
  lib,
  stdenv,
  attrs,
  autoray ? null,
  buildPythonPackage,
  duet,
  fetchFromGitHub,
  freezegun,
  matplotlib,
  networkx,
  numpy,
  opt-einsum,
  pandas,
  ply,
  pylatex ? null,
  pyquil ? null,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  quimb ? null,
  requests,
  scipy,
  setuptools,
  sortedcontainers,
  sympy,
  tqdm,
  typing-extensions,
  withContribRequires ? false,
}:

buildPythonPackage rec {
  pname = "cirq-core";
  version = "1.4.1-unstable-2024-09-21";
  pyproject = true;

  disabled = pythonOlder "3.10";

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

  disabledTests =
    [
      # Assertion error
      "test_parameterized_cphase"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # https://github.com/quantumlib/Cirq/issues/5924
      "test_prepare_two_qubit_state_using_sqrt_iswap"
    ];

  meta = with lib; {
    description = "Framework for creating, editing, and invoking Noisy Intermediate Scale Quantum (NISQ) circuits";
    homepage = "https://github.com/quantumlib/cirq";
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      drewrisinger
      fab
    ];
  };
}
