{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  aiohttp,
  attrs,
  jsonpatch,
  yarl,
  typing-extensions,

  # optional deps
  kubernetes,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  pytest-mock,
  looptime,
  aresponses,
}:

buildPythonPackage (finalAttrs: {
  pname = "kmock";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nolar";
    repo = "kmock";
    tag = finalAttrs.version;
    hash = "sha256-XXJEqAIK+k+6M0mfClboQLP3D/l1u06DTJzAH10LFps=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    attrs
    jsonpatch
    yarl
    typing-extensions
  ];

  optional-dependencies = {
    fetch = [ kubernetes ];
  };

  pythonImportsCheck = [ "kmock" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    aresponses
    looptime
  ];

  disabledTests = [
    # Could not contact DNS servers
    "test_bare_host_resolution"
    # Cannot connect to host clients3.google.com
    "test_hostname_interception"
    # Timeout
    "test_arbitrary_stream"
    "test_kubernetes_watch_stream"
    # assert 0 == 1
    "test_sync_condition_notifying"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "HTTP/API/Kubernetes Mock Server in Python";
    homepage = "https://github.com/nolar/kmock";
    changelog = "https://github.com/nolar/kmock/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
