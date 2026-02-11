{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fixtures,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  rich,
  setuptools,
  urllib3,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "podman";
  version = "5.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GbgqwsFBXE3kXdOpbbcmIEkj5FWNBqyWdq2tZQbvK8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
  ];

  optional-dependencies = {
    progress_bar = [ rich ];
  };

  nativeCheckInputs = [
    fixtures
    pytestCheckHook
    requests-mock
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "podman" ];

  disabledTests = [
    # Integration tests require a running container setup
    "AdapterIntegrationTest"
    "ContainersIntegrationTest"
    "ContainersExecIntegrationTests"
    "ImagesIntegrationTest"
    "ManifestsIntegrationTest"
    "NetworksIntegrationTest"
    "PodsIntegrationTest"
    "SecretsIntegrationTest"
    "SystemIntegrationTest"
    "VolumesIntegrationTest"
  ];

  disabledTestPaths = [
    # Access to the host's filesystem
    "podman/tests/integration/test_container_create.py"
    "podman/tests/unit/test_utils.py"
    "podman/tests/integration/test_volumes.py"
  ];

  meta = {
    description = "Python bindings for Podman's RESTful API";
    homepage = "https://github.com/containers/podman-py";
    changelog = "https://github.com/containers/podman-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
