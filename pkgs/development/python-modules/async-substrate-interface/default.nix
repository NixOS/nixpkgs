{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiosqlite,
  cyscale,
  websockets,
  xxhash,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "async-substrate-interface";
  version = "2.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "async-substrate-interface";
    tag = "v${finalAttrs.version}";
    hash = "sha256-39QL0h47ubKI26rIYxniNlchNAFEkPtKw6MyKuu2AXY=";
  };

  # On darwin the sandbox isolation is not as strict as on linux,
  # and we can get permission erros when trying to create/delete arbitrary dirs in /tmp
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace tests/unit_tests/test_types.py \
      --replace-fail '/tmp/async-substrate-interface-test-cache' "$(mktemp -d)/cache"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiosqlite
    cyscale
    websockets
    xxhash
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  # these tests open a live websocket/subtensor endpoint, unavailable in the build sandbox
  disabledTestPaths = [
    "tests/integration_tests"
    "tests/e2e_tests"
    "tests/unit_tests/sync/test_block.py"
  ];

  pythonImportsCheck = [ "async_substrate_interface" ];

  meta = {
    description = "Modernised py-substrate-interface and associated utils";
    longDescription = "This project provides an asynchronous interface for interacting with Substrate-based blockchains. It is based on the py-substrate-interface project.";
    homepage = "https://github.com/latent-to/async-substrate-interface";
    changelog = "https://github.com/latent-to/async-substrate-interface/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
