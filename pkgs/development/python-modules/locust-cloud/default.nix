{
  lib,
  buildPythonPackage,
  configargparse,
  fetchFromGitHub,
  gevent,
  hatch-vcs,
  hatchling,
  platformdirs,
  python-engineio,
  python-socketio,
  requests,
  gevent-websocket,
  tomli,
  flask,
  requests-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "locust-cloud";
  version = "1.29.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "locustcloud";
    repo = "locust-cloud";
    tag = version;
    hash = "sha256-3rlHtOSYMfHbNdWpo59OXS1Z1BWY99d7AKmZZuxAz9E=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    configargparse
    gevent
    platformdirs
    python-engineio
    python-socketio
    requests
    tomli
  ];

  nativeCheckInputs = [
    flask
    gevent-websocket
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "locust_cloud" ];

  preCheck = ''
    export LOCUSTCLOUD_USERNAME=dummy
    export LOCUSTCLOUD_PASSWORD=dummy
  '';

  disabledTests = [
    # AssertionError
    "test_recursive_imports"
    "test_from_import_file"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/web_login_test.py"
    "tests/cloud_test.py"
    "tests/websocket_test.py"
  ];

  meta = {
    description = "Hosted version of Locust to run distributed load tests";
    homepage = "https://github.com/locustcloud/locust-cloud";
    changelog = "https://github.com/locustcloud/locust-cloud/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ magicquark ];
  };
}
