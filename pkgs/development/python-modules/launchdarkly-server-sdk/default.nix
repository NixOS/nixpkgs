{
  buildPythonPackage,
  certifi,
  expiringdict,
  fetchFromGitHub,
  jsonpickle,
  launchdarkly-eventsource,
  lib,
  mock,
  nix-update-script,
  poetry-core,
  pyrfc3339,
  pytestCheckHook,
  pyyaml,
  redis,
  redisTestHook,
  semver,
  urllib3,
}:

buildPythonPackage rec {
  pname = "launchdarkly-server-sdk";
  version = "9.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "launchdarkly";
    repo = "python-server-sdk";
    tag = version;
    hash = "sha256-iE27AWOMasycn2oiuXXwKxJyIvhAcQafN+v5N/AN/7s=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    launchdarkly-eventsource
    certifi
    expiringdict
    pyrfc3339
    semver
    urllib3
  ];

  nativeCheckInputs = [
    jsonpickle
    mock
    pytestCheckHook
    pyyaml
    redis
    redisTestHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LaunchDarkly Server-side SDK for Python";
    homepage = "https://github.com/launchdarkly/python-server-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/launchdarkly/python-server-sdk/releases/tag/${src.tag}";
  };
}
