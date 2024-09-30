{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  isPyPy,
  pythonOlder,
  cytoolz,
  eth-hash,
  eth-typing,
  hypothesis,
  mypy,
  pytestCheckHook,
  pytest-xdist,
  setuptools,
  toolz,
}:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "5.0.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-bBtNdwvg8fY2aWWmBJV07oSGb5rR29aPbAyG9fnO8ic=";
  };

  patches = [
    (fetchpatch2 {
      # Merged but unreleased: https://github.com/ethereum/eth-utils/pull/284
      name = "fix-cyclic-dependency.patch";
      url = "https://github.com/ethereum/eth-utils/commit/c27072b6caf758f02d2eda8b1ee004d772e491dd.patch";
      hash = "sha256-7gKxRXDZmiWxQxA+OPCB32wS1hoA0ChjGOlRRD281I4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    eth-hash
    eth-typing
  ] ++ lib.optional (!isPyPy) cytoolz ++ lib.optional isPyPy toolz;

  nativeCheckInputs = [
    hypothesis
    mypy
    pytestCheckHook
    pytest-xdist
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  # side-effect: runs pip online check and is blocked by sandbox
  disabledTests = [ "test_install_local_wheel" ];

  pythonImportsCheck = [ "eth_utils" ];

  meta = {
    changelog = "https://github.com/ethereum/eth-utils/blob/${src.rev}/docs/release_notes.rst";
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
}
