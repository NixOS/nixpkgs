{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    tag = "v${version}";
    hash = "sha256-M+ojGXJOnrBipjSA9hd3++yTS70kCjPru9FG/rm7zI8=";
  };

  sourceRoot = "${src.name}/${pname}";

  patches = [
    # Upstream PR: https://github.com/quantumlib/Cirq/pull/7761
    (fetchpatch {
      name = "python-3.14.patch";
      url = "https://github.com/quantumlib/Cirq/commit/9aea3bad824cac77031c163d6d6f5cf3e01cfe80.patch";
      stripLen = 1;
      includes = [ "cirq/ops/linear_combinations_test.py" ];
      hash = "sha256-Ggcaswrdx6mOfNOwlbWE2ix7aZWt3/Fljb4i1ow+lUU=";
    })
  ];

  pythonRelaxDeps = [ "matplotlib" ];

  build-system = [ setuptools ];

  dependencies = [
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

  disabledTests = [
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
    changelog = "https://github.com/quantumlib/Cirq/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
    ];
  };
}
