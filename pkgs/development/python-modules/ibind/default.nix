{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  pycryptodome,
  requests,
  urllib3,
  websocket-client,

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ibind";
  version = "0.1.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Voyz";
    repo = "ibind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hFjxkAEbhbcwseI7XwrEBtq5kzGj6XRBw3mqcxar9r0=";
  };

  postUnpack = ''
    rm -r "$sourceRoot/dist"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    pycryptodome
    requests
    urllib3
    websocket-client
  ];

  pythonRelaxDeps = [
    "requests"
    "websocket-client"
  ];

  preCheck = ''
    # The file format is just wrong(?)
    # NOTE: already fixed upstream, remove when not needed anymore
    substituteInPlace "pytest.ini" \
      --replace-fail '[tool:pytest]' '[pytest]'
  '';
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # On macOS the timeout seems to be less precise than the testcase expects
    "test/unit/support/test_py_utils_u.py::TestWaitUntilU::test_wait_until_timeout"
  ];

  pythonImportsCheck = [ "ibind" ];

  meta = {
    changelog = "https://github.com/Voyz/ibind/releases/tag/${finalAttrs.src.tag}";
    description = "REST and WebSocket client library for Interactive Brokers Client Portal Web API";
    homepage = "https://github.com/Voyz/ibind";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kirelagin ];
  };
})
