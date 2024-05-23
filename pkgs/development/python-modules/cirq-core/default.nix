{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
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
  # Contrib requirements
  withContribRequires ? false,
  autoray ? null,
  opt-einsum,
  ply,
  pylatex ? null,
  pyquil ? null,
  quimb ? null,
  # test inputs
  pytestCheckHook,
  freezegun,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "cirq-core";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "quantumlib";
    repo = "cirq";
    rev = "refs/tags/v${version}";
    hash = "sha256-JAJJciFg3BuRha1wTKixtKWcYy3NA2mNpniPyPHTTe8=";
  };

  sourceRoot = "${src.name}/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "matplotlib~=3.0" "matplotlib"
  '';

  propagatedBuildInputs =
    [
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

  disabledTests = lib.optionals stdenv.isAarch64 [
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
