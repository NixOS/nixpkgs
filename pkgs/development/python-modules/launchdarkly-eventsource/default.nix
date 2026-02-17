{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  poetry-core,
  pytestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "launchdarkly_eventsource";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "launchdarkly";
    repo = "python-eventsource";
    tag = version;
    hash = "sha256-NA/opx+eLRDyIgjPtuG6JPoqM6gBDjF6BjkNG1th+u4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Server-Sent Events client for Python ";
    homepage = "https://github.com/launchdarkly/python-eventsource";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/launchdarkly/python-eventsource/releases/tag/${src.tag}";
  };
}
