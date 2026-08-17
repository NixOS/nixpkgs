{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  async-substrate-interface,
  asyncstdlib,
  bittensor-drand,
  bittensor-wallet,
  colorama,
  cyscale,
  fastapi,
  msgpack-numpy-opentensor,
  netaddr,
  numpy,
  packaging,
  pycryptodome,
  pydantic,
  python-statemachine,
  pyyaml,
  requests,
  retry,
  uvicorn,
  freezegun,
  httpx,
  hypothesis,
  pytest-mock,
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bittensor";
  version = "10.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "bittensor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4oP0QIrKoxNKJWKpO1Ns4Z3O+e8XniVL9ONwr934Q7k=";
  };

  # python-statemachine >= 3.1 stores its active-state Configuration on `self._config`,
  # which collides with LoggingMachine's logging-config attribute of the same name and
  # breaks import ("'NoneType' object is not iterable"). Rename the latter. Drop once
  # upstream relaxes/supports python-statemachine 3.x.
  postPatch = ''
    substituteInPlace bittensor/utils/btlogging/loggingmachine.py \
      --replace-fail 'self._config = ' 'self._logging_config = ' \
      --replace-fail 'self._config.' 'self._logging_config.' \
      --replace-fail '(self._config)' '(self._logging_config)' \
      --replace-fail 'return self._config' 'return self._logging_config'
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "asyncstdlib"
    "python-statemachine"
  ];

  dependencies = [
    aiohttp
    async-substrate-interface
    asyncstdlib
    bittensor-drand
    bittensor-wallet
    colorama
    cyscale
    fastapi
    msgpack-numpy-opentensor
    netaddr
    numpy
    packaging
    pycryptodome
    pydantic
    python-statemachine
    pyyaml
    requests
    retry
    uvicorn
  ];

  nativeBuildInputs = [
    # bittensor/core/settings.py calls Path.home().mkdir() at import time.
    # This is also hit by pythonImportsCheck when doCheck = false, so this does not go in nativeCheckInputs
    writableTmpDirAsHomeHook
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    httpx
    hypothesis
    pytest-mock
    pytestCheckHook
    pytest-asyncio
  ];

  # integration/e2e tests require a live subtensor node; torch tests require optional dep
  disabledTestPaths = [
    "tests/e2e_tests"
    "tests/integration_tests"
    "tests/unit_tests/test_chain_data.py"
    "tests/unit_tests/test_tensor.py"
    "tests/unit_tests/utils/test_weight_utils.py"
  ];

  disabledTests = [
    # requires torch, which would be a very large dependency to pull in for one test
    "test_lazy_loaded_torch__torch_installed"
    # requires network
    "test__methods_comparable_with_passed_legacy_methods"
    # issues with sandbox
    "test_sync_warning_cases"
    # statemachine 3.0 emits extra internal debug logs not expected by the test which expect an older version
    "test_all_log_levels_output"
    # Broken wiith aiohttp 3.13, can be re-enabled once https://github.com/NixOS/nixpkgs/pull/526853 hits master
    "test_dendrite__call__success_response"
    "test_dendrite__call__handles_http_error_response"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # This test requires local networking, yet this gets
    # blocked by the sandbox even with `__darwinAllowLocalNetworking`
    "test_threaded_fastapi"
  ];

  pythonImportsCheck = [ "bittensor" ];

  meta = {
    description = "Bittensor SDK";
    homepage = "https://github.com/latent-to/bittensor";
    changelog = "https://github.com/latent-to/bittensor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
