{ lib
, buildPythonPackage
, fetchFromGitHub
, fixtures
, pytestCheckHook
, pythonOlder
, pyxdg
, requests
, requests-mock
, rich
, setuptools
, tomli
, urllib3
}:

buildPythonPackage rec {
  pname = "podman";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-lw8ZW1Uh6pbL5Z15NBBgKFm1143rEyFdecBHsSwBYVo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyxdg
    requests
    rich
    tomli
    urllib3
  ];

  nativeCheckInputs = [
    fixtures
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "podman"
  ];

  disabledTests = [
    # Integration tests require a running container setup
    "AdapterIntegrationTest"
    "ContainersIntegrationTest"
    "ImagesIntegrationTest"
    "ManifestsIntegrationTest"
    "NetworksIntegrationTest"
    "PodsIntegrationTest"
    "SecretsIntegrationTest"
    "SystemIntegrationTest"
    "VolumesIntegrationTest"
  ];

  meta = with lib; {
    description = "Python bindings for Podman's RESTful API";
    homepage = "https://github.com/containers/podman-py";
    changelog = "https://github.com/containers/podman-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "podman";
  };
}
