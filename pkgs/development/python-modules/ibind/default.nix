{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pycryptodome,
  requests,
  urllib3,
  websocket-client,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ibind";
  version = "0.1.22";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Voyz";
    repo = "ibind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hFjxkAEbhbcwseI7XwrEBtq5kzGj6XRBw3mqcxar9r0=";
  };

  # Otherwise, fails with:
  # __main__.py: error: unrecognized arguments: unpacked/ibind-0.0.2
  postUnpack = ''
    rm -r "$sourceRoot/dist"
  '';

  # ModuleNotFoundError: No module named 'test_utils'
  # TODO: The fix is already merged upstream: remove when updating to the next release
  postPatch = ''
    substituteInPlace "pytest.ini" \
      --replace-fail '[tool:pytest]' '[pytest]'
  '';

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "requests"
    "websocket-client"
  ];
  dependencies = [
    pycryptodome
    requests
    urllib3
    websocket-client
  ];

  pythonImportsCheck = [ "ibind" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: 0.2564859390258789 != 0.1 within 0.02 delta (0.1564859390258789 difference)
    "test_wait_until_timeout"
  ];

  meta = {
    description = "REST and WebSocket client library for Interactive Brokers Client Portal Web API";
    homepage = "https://github.com/Voyz/ibind";
    changelog = "https://github.com/Voyz/ibind/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
