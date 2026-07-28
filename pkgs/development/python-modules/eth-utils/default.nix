{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  isPyPy,

  # dependencies
  eth-hash,
  eth-typing,
  cytoolz,
  toolz,
  pydantic,

  # tests
  hypothesis,
  mypy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "eth-utils";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-utils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U1RSKaLw/gDg4lMjkTwR/Wfb5wqQctML9CDZBILMBys=";
  };

  postPatch = ''
    # type inference test output expectation changed slightly (don't ask me when it started...)
    sed -i 's/builtins\.//g' tests/core/functional-utils/test_type_inference.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    eth-hash
    eth-typing
  ]
  ++ lib.optional (!isPyPy) cytoolz
  ++ lib.optional isPyPy toolz;

  nativeCheckInputs = [
    hypothesis
    mypy
    pytestCheckHook
    pydantic
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_utils" ];

  disabledTests = [
    # Exception: Expected one wheel. Instead found: [] in project /build/source
    "test_install_local_wheel"
  ];

  disabledTestPaths = [
    # Typing tests fail like:
    #   Revealed type is "builtins.tuple[builtins.int, ...]"
    "tests/core/functional-utils/test_type_inference.py"
  ];

  meta = {
    changelog = "https://github.com/ethereum/eth-utils/blob/${finalAttrs.src.tag}/docs/release_notes.rst";
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
})
