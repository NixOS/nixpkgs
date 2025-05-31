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
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    tag = "v${version}";
    hash = "sha256-4FgXX4ox7BkjmLecxsvg0/JpcrHPn6hlFw5rk4bn9Cc=";
  };

  sourceRoot = "${src.name}/${pname}";

  pythonRelaxDeps = [ "matplotlib" ];

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
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # test_scalar_division[scalar9-terms9-terms_expected9] result differs in the final digit
      "test_scalar_division"
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
